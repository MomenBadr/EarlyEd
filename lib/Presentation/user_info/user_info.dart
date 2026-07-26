import 'package:cached_network_image/cached_network_image.dart';
import 'package:early_ed/helpers/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.userName,
    required this.age,
    required this.imageUrl,
    required this.level,
    required this.type,
  });

  final String userName, imageUrl, type;
  final int age, level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        title: Column(
          children: [
            Image.asset(
              "assets/images/EARLYED.png",
              width: 150,
              height: 100.h,
              fit: BoxFit.fill,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.lightBlue,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
              alignment: Alignment.center,
              child: const Text(
                "STUDENT INFO",
                style: TextStyle(color: Colors.white, fontSize: 36),
              ),
            ),
            ClipOval(
                child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    height: 200.h,
                    width: 200.w,
                    imageUrl: imageUrl,
                    // errorWidget: (context, url, error) => const CustomImage(imagePath: AppAssets.errorImage),
                    // placeholder: (context, url) => const CustomImage(imagePath: AppAssets.placeholder),
                    progressIndicatorBuilder: (context, url, progress) =>
                        SizedBox(
                            width: 200.w,
                            child: const Center(
                                child: CircularProgressIndicator())))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: Alignment.center,
              child: Text(
                userName,
                style: const TextStyle(color: Colors.white, fontSize: 36),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
              alignment: Alignment.center,
              child: Text(
                "$age YEARS OLD",
                style: const TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
              alignment: Alignment.center,
              child: Text(
                type == 'ad'
                    ? "Admin"
                    : type == 'te'
                        ? 'Teacher'
                        : level == 1
                            ? 'First Grade'
                            : level == 2
                                ? 'Second Grade'
                                : level == 3
                                    ? 'Third Grade'
                                    : level == 4
                                        ? 'Fourth Grade'
                                        : level == 5
                                            ? 'Fifth Grade'
                                            : 'Sixth Grade',
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 70.h),
              // height:100 ,
              alignment: Alignment.bottomCenter,
              child: FilledButton(
                child: const Text(
                  "LOG OUT",
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () {
                  logOut(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
