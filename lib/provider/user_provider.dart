import 'package:flutter/widgets.dart';
import 'package:predict_vip/resources/authentication.dart';
import 'package:predict_vip/models/user.dart';

class UserProvider with ChangeNotifier {
  UserData _user;
  AuthMethods _authMethods = AuthMethods();

  UserData get getUser => _user;

  Future<void> refreshUser() async {
    UserData user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
