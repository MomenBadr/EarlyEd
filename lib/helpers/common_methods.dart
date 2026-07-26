import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/helpers/shared_data.dart';
import 'package:early_ed/Presentation/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}

logOut(BuildContext context) async {
  SharedData.user = null;
  await auth.signOut();
  SharedPreferences s = await SharedPreferences.getInstance();
  s.clear();
  Navigator.pushNamedAndRemoveUntil(
      context, AuthScreen.routeName, (route) => false);
}
