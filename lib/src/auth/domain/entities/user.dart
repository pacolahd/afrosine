import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  // We can give things default values too
  const LocalUser(
      {required this.uid,
      required this.email,
      required this.userName,
      required this.favoriteRecipeIds});

  // Named constructor to create an empty user for testing
  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          userName: '',
          favoriteRecipeIds: const [],
        );

  final String uid;
  final String email;
  final String userName;
  final List<String> favoriteRecipeIds;

  @override
  // How do we check if one instance of a user is the same as another?
  List<Object?> get props => [
        uid,
        email,
        userName,
        favoriteRecipeIds,
      ];

// When we print LocalUser, we get the uid and email, etc of the user because it has been stringified by default
  // we can set it to false if we don't want this
  // @override
  // bool get stringify => true or false;

  // We can also just override the toString method to return a custom string to be displayed with the user is printed
  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, userName: $userName}';
  }
}
