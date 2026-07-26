import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/Presentation/auth/auth_screen.dart';
import 'package:early_ed/Presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) =>
        Navigator.pushNamedAndRemoveUntil(
            context,
            auth.currentUser != null
                ? HomeScreen.routeName
                : AuthScreen.routeName,
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Image.asset(
          "assets/images/LOGO1.png",
          width: 150.w,
          height: 140.h,
        ),
      ),
    );
  }
}
