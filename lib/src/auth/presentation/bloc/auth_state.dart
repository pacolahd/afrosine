part of 'auth_bloc.dart';

// The repository functionality is split into a state and an event

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// the return types of the methods in the auth repo are passed to the state as attributes,
// essentially creating a class from the repo but different from the event

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class SignedIn extends AuthState {
  const SignedIn({
    required this.user,
  });

  // only in the datasource do we use the model
  final LocalUser user;

  @override
  List<Object> get props => [user];
}
// final class SignedIn extends AuthState {
//   const SignedIn({
//     required this.user,
//     required this.isAdmin,
//   });
//
//   // only in the datasource do we use the model
//   final LocalUser user;
//   final bool isAdmin;
//
//   @override
//   List<Object> get props => [user];
// }

class SignedUp extends AuthState {
  const SignedUp();
}

class ForgotPasswordSent extends AuthState {
  const ForgotPasswordSent();
}

class UserUpdated extends AuthState {
  const UserUpdated();
}

final class AuthError extends AuthState {
  const AuthError({
    required this.message,
  });

  final String message;

  @override
  List<String> get props => [message];
}
