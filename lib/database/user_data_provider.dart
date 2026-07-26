import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  String userName = '',
      userEmail = '',
      userId = '',
      parentOrChildName = '',
      password = '',
      type = '',
      userImageUrl = '',
      subject = '',
      childId = '';
  int level = 0, age = 0;
  List<String> arabicGrades = [],
      englishGrades = [],
      mathGrades = [],
      scienceGrades = [],
      weekAtt = [];

  void setData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'userName':
        {
          userName = value;
          prefs.setString(key, userName);
          break;
        }
      case 'childId':
        {
          childId = value;
          prefs.setString(key, childId);
          break;
        }
      case 'type':
        {
          type = value;
          prefs.setString(key, type);
          break;
        }
      case 'userImageUrl':
        {
          userImageUrl = value;
          prefs.setString(key, userImageUrl);
          break;
        }
      case 'subject':
        {
          subject = value;
          prefs.setString(key, subject);
          break;
        }
      case 'age':
        {
          age = value;
          prefs.setInt(key, age);
          break;
        }
      case 'level':
        {
          level = value;
          prefs.setInt(key, level);
          break;
        }
      case 'password':
        {
          password = value;
          prefs.setString(key, password);
          break;
        }
      case 'parenOrChildName':
        {
          parentOrChildName = value;
          prefs.setString(key, parentOrChildName);
          break;
        }
      case 'userId':
        {
          userId = value;
          prefs.setString(key, userId);
          break;
        }
      case 'arabicGrades':
        {
          arabicGrades = value;
          prefs.setStringList(key, arabicGrades);
          break;
        }
      case 'scienceGrades':
        {
          scienceGrades = value;
          prefs.setStringList(key, scienceGrades);
          break;
        }
      case 'mathGrades':
        {
          mathGrades = value;
          prefs.setStringList(key, mathGrades);
          break;
        }
      case 'englishGrades':
        {
          englishGrades = value;
          prefs.setStringList(key, englishGrades);
          break;
        }
      case 'weekAtt':
        {
          weekAtt = value;
          prefs.setStringList(key, weekAtt);
          break;
        }
      case 'userEmail':
        {
          userEmail = value;
          prefs.setString(key, userEmail);
          break;
        }
    }
    //notifyListeners();
  }
}
