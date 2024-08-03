part of 'auth_bloc.dart';

// The repository functionality is split into a state and an event

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

// the attributes of the auth auth repo are passed to the event as attributes,
// essentially creating a class from the repo

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.userName,
    required this.email,
    required this.password,
  });

  final String userName;
  final String email;
  final String password;

  @override
  List<Object> get props => [userName, email, password];
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({
    required this.action,
    required this.userData,
  }) : assert(
          userData is String || userData is File,
          'userData must be a String or a File but was ${userData.runtimeType}',
        );
  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
