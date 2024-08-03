import 'dart:convert';

import 'package:afrosine/core/enums/update_user.dart';
import 'package:afrosine/core/errors/exceptions.dart';
import 'package:afrosine/core/utils/constants.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// this is the abstract class that defines the methods that will be implemented in the AuthRemoteDataSourceImpl
// This class is used to define the methods that will be used to interact with the server
// Now, the AuthRemoteDataSourceImpl will implement this class and define the methods that will be used to interact with the server

// This means we can use any type of server (firebase, supabase, etc) to interact with the app by just implementing this class

// The AuthRepoImpl will then use the methods defined in the AuthRemoteDataSourceImpl to interact with the server

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword({required String email});

  // We use the model (LocalUserModel) of the base user and not the entity (LocalUser)  because the model is the one that is used to convert the data from the server
  // It is the model that is used to convert the data from the server to an object that can be used in the app
  // It has the fromMap, toMap and copyWith methods that are used to convert the data
  // It also helps us if we have multiple user types where we can have a model for each user type
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

// This is the implementation of the AuthRemoteDataSource

// This class is used to define the methods that will be used to interact with the server
// Here we are using firebase as the server but we can use any server by just implementing the AuthRemoteDataSource class

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        // the firebase auth exception's message is nullable so we use the null aware operator to check if it is null
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
      // if it's not a FirebaseAuthException, we catch it and throw a ServerException
    } catch (e, s) {
      // When catching, we can stack trace to help us debug the error
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      // if the user doc exists, we get it from the server
      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      // if the user doc doesn't exist, we upload it to the server
      await _setUserData(user, email);

      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } // if it's a server exception we defined above, we rethrow it
    on ServerException {
      rethrow;
    } // Else we catch the error and throw a ServerException
    catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Once the user is created, we update the user's display name and photo url
      await userCredential.user?.updateDisplayName(userName);
      await userCredential.user?.updatePhotoURL(kDefaultAvatar);
      // We then set the user data in the server
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser
              ?.verifyBeforeUpdateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.userName:
          await _updateUserData({'userName': userData as String});

        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exits',
              statusCode: 'Insufficient Permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          // We reauthenticate the user before updating the password, as advised by the documentation
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    final userDoc = await _cloudStoreClient.collection('users').doc(uid).get();
    return userDoc;
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            userName: user.displayName ?? '',
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser!.uid)
        .update(data);
  }
}
