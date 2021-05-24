import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoginKey = "isLoggedIn";
  static String SharedPreferenceUserNameKey = "USERNAMEKEY";
  static String SharedPreferenceUsereUIDKey = "USERUIDKEY";

//  SAVING DATA TO SHARED pREFRENCE
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setBool(sharedPreferenceUserLoginKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userNmae) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(SharedPreferenceUserNameKey, userNmae);
  }
  static Future<bool> remove() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(sharedPreferenceUserLoginKey);
    await _prefs.remove(SharedPreferenceUserNameKey);
    await _prefs.remove(SharedPreferenceUsereUIDKey);
  }

  static Future<bool> saveUserUIDSharedPreference(String UID) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(SharedPreferenceUsereUIDKey, UID);
  }

//  getting data from shared preference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getBool(sharedPreferenceUserLoginKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(SharedPreferenceUserNameKey);
  }

  static Future<String> getUserUIDSharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(SharedPreferenceUsereUIDKey);
  }
}
