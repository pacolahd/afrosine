import 'package:afrosine/core/enums/update_user.dart';
import 'package:afrosine/core/errors/exceptions.dart';
import 'package:afrosine/core/errors/failures.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:afrosine/src/auth/domain/entities/user.dart';
import 'package:afrosine/src/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signUp(
        userName: userName,
        email: email,
        password: password,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      await _remoteDataSource.updateUser(
        action: action,
        userData: userData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
