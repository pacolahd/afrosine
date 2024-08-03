import 'package:afrosine/src/auth/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  // create a private user
  LocalUserModel? _user;

  // create a getter for the user
  LocalUserModel? get user => _user;

  // initialise the user the first time the app gets a user
  void initUser(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      // notifyListeners();
    }
  }

  // update the user when something changes, logout and logged in
  void setUser(LocalUserModel user) {
    if (_user != user) {
      _user = user;
      // We're updating the user here because we want to notify the listeners that the user has changed.
      // What if the page is already building or sth is already going on in our page?
      // we can't just call the notifyListeners() method because it will notify the listeners immediately.
      // We want to notify the listeners only when the page is ready to be updated.
      // So we use the Future.delayed method to wait for the page to be ready before we notify the listeners.

      Future.delayed(Duration.zero, notifyListeners);
      // notifyListeners();
    }
  }
  // we will call this as userProvider.user = user;

  // can also do void setUser(LocalUserModel user) {
  //   ...
  // }
  // and call it like this: userProvider.setUser(user);
}
