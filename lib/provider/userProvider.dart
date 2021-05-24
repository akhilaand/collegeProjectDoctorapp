import 'package:college_project_doctor/modal/user.dart';
import 'package:college_project_doctor/services/database.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User1 _user;
  DataBaseMethods _database = DataBaseMethods();
  User1 get getUser => _user;
  Future<void> refreshUser() async {
    User1 user = await _database.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
