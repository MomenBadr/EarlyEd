import 'dart:developer';

import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/database/user_data_provider.dart';
import 'package:early_ed/helpers/shared_data.dart';
import 'package:early_ed/Presentation/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/forgot_password.dart';
import 'components/login_signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const String routeName = 'Auth Screen';

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  bool _forgotpassowrd = false;
  void _forgotPasswordMethod() {
    setState(() {
      _forgotpassowrd = !_forgotpassowrd;
    });
  }

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection("userslist")
            .doc(authResult.user!.uid)
            .set(
          {
            'userId': authResult.user!.uid,
            'userName': username,
            'userEmail': email,
            'password': password,
            'userImageUrl':
                "https://www12.0zz0.com/2021/05/21/20/865510145.png",
            'createdAt': Timestamp.now(),
            'lastSeen': FieldValue.serverTimestamp(),
          },
        );
        authResult.user!.updatePhotoURL(
            "https://www12.0zz0.com/2021/05/21/20/865510145.png");
        authResult.user!.updateDisplayName(username);
      }
      log(authResult.user?.uid ?? 'nullllll');
      var retrievedUser =
          await MyDataBase.getUserById(authResult.user?.uid ?? '');
      var userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      userDataProvider.setData(
          'arabicGrades',
          (retrievedUser?.arabicGrades ?? [])
              .map((item) => item.toString())
              .toList());
      userDataProvider.setData('userEmail', retrievedUser?.userEmail ?? '');
      userDataProvider.setData(
          'userImageUrl', retrievedUser?.userImageUrl ?? '');
      userDataProvider.setData('subject', retrievedUser?.subject ?? '');
      userDataProvider.setData('level', retrievedUser?.level ?? 0);
      userDataProvider.setData('age', retrievedUser?.age ?? 0);
      userDataProvider.setData(
          'englishGrades',
          (retrievedUser?.englishGrades ?? [])
              .map((item) => item.toString())
              .toList());
      userDataProvider.setData('userName', retrievedUser?.userName ?? '');
      userDataProvider.setData('userId', retrievedUser?.userId ?? '');
      userDataProvider.setData(
          'mathGrades',
          (retrievedUser?.mathGrades ?? [])
              .map((item) => item.toString())
              .toList());
      userDataProvider.setData(
          'parentOrChildName', retrievedUser?.parentOrChildName ?? '');
      userDataProvider.setData('password', retrievedUser?.password ?? '');
      userDataProvider.setData(
          'scienceGrades',
          (retrievedUser?.scienceGrades ?? [])
              .map((item) => item.toString())
              .toList());
      userDataProvider.setData(
          'weekAtt',
          (retrievedUser?.weekAtt ?? [])
              .map((item) => item.toString())
              .toList());
      userDataProvider.setData('type', retrievedUser?.type ?? '');
      userDataProvider.setData('childId', retrievedUser?.childId ?? '');
      if (retrievedUser != null) {
        SharedData.user = retrievedUser;
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String message = "internet connection error.";
      if (e.code == 'weak-password') {
        message = 'password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'this account already exists.';
      } else if (e.code == 'user-not-found') {
        message = 'email is not found.';
      } else if (e.code == 'wrong-password') {
        message = 'wrong password.';
      } else if (e.code == 'invalid-email') {
        message = 'invalid email.';
      } else if (e.code == 'network-request-failed') {
        message = 'network connection error.';
      } else {
        message = e.code;
      }
      showDialog(
          // ignore: use_build_context_synchronously
          context: ctx,
          builder: (ctxx) => AlertDialog(
                title: const Text("Server responde :"),
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _forgotpassowrd
            ? ForgotPassword(_forgotPasswordMethod)
            : LogScreen(_forgotPasswordMethod, _submitAuthForm, _isLoading),
      ),
    );
  }
}
