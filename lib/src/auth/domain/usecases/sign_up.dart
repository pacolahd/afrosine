import 'package:afrosine/core/usecases/usecases.dart';
import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends UseCaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
        userName: params.userName,
        email: params.email,
        password: params.password,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.userName,
    required this.email,
    required this.password,
  });

  const SignUpParams.empty()
      : this(
          userName: '',
          email: '',
          password: '',
        );

  final String userName;
  final String email;
  final String password;

  @override
  List<Object?> get props => [userName, email, password];
}
