
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    debugPrint('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return "lightMode";
    }
  }

  Future<void> setCompanyLogo(String value) {
    return _sharedPreferences!.setString('companyLogo', value);
  }

  String getCompanyLogo() {
    try {
      return _sharedPreferences!.getString('companyLogo')!;
    } catch (e) {
      return "";
    }
  }

  Future<void> setLanguage(String value) {
    return _sharedPreferences!.setString('language', value);
  }

  // Future<void> setUserSubscribedTopics(List<String> value) {
  //   return _sharedPreferences!.setStringList("usersTopicsList", value);
  // }
  // List<String> getUserSubscribedTopics() {
  //   try{
  //     return _sharedPreferences!.getStringList("usersTopicsList") ?? ["All"];
  //   }catch(_){
  //     return ["All"];
  //   }
  //
  // }

  String getLanguage() {
    try {
      return _sharedPreferences!.getString('language')!;
    } catch (e) {
      return "ar";
    }
  }

  // Future<void> setCurrentUserSubscribedData(bool subscribed) {
  //   return _sharedPreferences!
  //       .setBool('current_user_subscribed_key', subscribed);
  // }

  Future<void> setIsUserLogin(bool isLogin) {
    return _sharedPreferences!.setBool('is_user_login', isLogin);
  }

  bool getIsUserLogin() {
    try {
      return _sharedPreferences?.getBool('is_user_login') ?? false;
    } catch (_) {
      return false;
    }
  }


  int getGeneralToastTimeInMinute() {
    try {
      return _sharedPreferences!.getInt('general_toast_time')!;
    } catch (e) {
      return 0;
    }
  }

  Future<void> setGeneralToastTimeInMinute(int value) {
    return _sharedPreferences!.setInt('general_toast_time', value);
  }

  // bool getCurrentUserSubscribedData() {
  //   try {
  //     return _sharedPreferences!.getBool('current_user_subscribed_key')!;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  bool getNotificationSubscribedData() {
    try {
      return _sharedPreferences!.getBool('notificationSubscribe')!;
    } catch (e) {
      return true;
    }
  }

  Future<void> setNotificationSubscribedData(bool value) {
    return _sharedPreferences!.setBool('notificationSubscribe', value);
  }

}
