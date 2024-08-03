import 'package:afrosine/core/enums/update_user.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<void> forgotPassword({
    required String email,
  });

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String userName,
    required String email,
    required String password,
  });

  ResultFuture<void> updateUser({
    // When trying to update the user data, we need to know exactly which field we are updating
    // This is why we have the UpdateUserAction enum
    // So we take both the action (defining what exactly we're updating) and the data to be updated
    required UpdateUserAction action,
    required dynamic userData,
  });
}
