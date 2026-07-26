import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/firebase_options.dart';
import 'package:early_ed/Presentation/school_info/school_info.dart';
import 'package:early_ed/Presentation/user_info/user_info.dart';
import 'package:early_ed/Presentation/attendance/attendance_screen.dart';
import 'package:early_ed/Presentation/grades/grades_screen.dart';
import 'package:early_ed/Presentation/news/news_screen.dart';
import 'package:early_ed/Presentation/select_screens/select_level_screen.dart';
import 'package:early_ed/Presentation/chat/user_chats/user_chats.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<String> _tokenStream;
  String userName = '',
      userEmail = '',
      userId = '',
      parentOrChild = '',
      password = '',
      subject = '',
      type = '',
      userImageUrl = '',
      childId = '';
  int age = 0, level = 0;
  List<String> mathGrades = [],
      englishGrades = [],
      scienceGrades = [],
      arabicGrades = [],
      weekAtt = [];
  void setToken(String? token) async {
    // ignore: avoid_print
    print('FCM Token Changed to be: $token');

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseFirestore.instance
        .collection('userslist')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'noti_token': token,
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    FirebaseMessaging.onMessage.listen(AppHelper.showFlutterNotification);

    FirebaseMessaging.instance
        .getToken(
            // TODO: Put token
            vapidKey: 'Put token Here')
        .onError(
      (error, stackTrace) {
        return null;
      },
    ).then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    loadData();
  }

  // استرجاع البيانات المحفوظة عند تحميل الصفحة
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userId = prefs.getString('userId') ?? '';
      parentOrChild = prefs.getString('parentOrChild') ?? '';
      password = prefs.getString('password') ?? '';
      subject = prefs.getString('subject') ?? '';
      type = prefs.getString('type') ?? '';
      userImageUrl = prefs.getString('userImageUrl') ?? '';
      childId = prefs.getString('childId') ?? '';
      age = prefs.getInt('age') ?? 0;
      level = prefs.getInt('level') ?? 0;
      mathGrades = prefs.getStringList('mathGrades') ?? [];
      arabicGrades = prefs.getStringList('arabicGrades') ?? [];
      scienceGrades = prefs.getStringList('scienceGrades') ?? [];
      englishGrades = prefs.getStringList('englishGrades') ?? [];
      weekAtt = prefs.getStringList('weekAtt') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    //final size =MediaQuery.of(context).size;
    // var userDataProvider = Provider.of<UserDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, size: 35),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        title: Text(
          "EARLYED -- $userName",
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SchoolInfo(),
                  ));
            },
            icon: const Icon(Icons.more_vert_rounded),
            iconSize: 30,
            color: Colors.black,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (type == 'ad' || type == 'te')
                            ? const SelectLevelScreen(
                                isGrades: true,
                              )
                            : GradesScreen(
                                math: mathGrades,
                                arabic: arabicGrades,
                                english: englishGrades,
                                science: scienceGrades,
                                studentId: auth.currentUser!.uid,
                                type: type,
                                subject: subject,
                                childId: childId)));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "GRADES",
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (type == 'st' || type == 'pa')
                          ? AttendanceScreen(
                              studentId: auth.currentUser!.uid,
                              type: type,
                              childId: childId)
                          : const SelectLevelScreen(
                              isGrades: false,
                            ),
                    ));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "ATTENDANCE",
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsScreen(canEdit: type == 'ad'),
                    ));
                log(type);
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "NEWS",
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfo(
                        userName: userName,
                        age: age,
                        imageUrl: userImageUrl,
                        level: level,
                        type: type,
                      ),
                    ));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "USER INFO",
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyChat(),
                    ));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "Chat",
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
            Transform.scale(
              scale: 1.15,
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                  // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  // width: 310,
                  // height: 210,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 6),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Image.asset(
                    "assets/images/student.jpg",
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
