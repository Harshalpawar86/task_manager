import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool darkTheme = false;
  ThemeController() {
    loadTheme();
  }
  void loadTheme() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    darkTheme = obj.getBool("darkTheme") ?? false;
    notifyListeners();
  }

  void changeTheme() async {
    darkTheme = !darkTheme;
    SharedPreferences obj = await SharedPreferences.getInstance();
    obj.setBool("darkTheme", darkTheme);
    notifyListeners();
  }
}
