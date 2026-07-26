import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/database/my_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen(
      {super.key,
      required this.math,
      required this.arabic,
      required this.english,
      required this.science,
      required this.studentId,
      required this.type,
      required this.subject,
      required this.childId});

  final List<String> math, arabic, english, science;
  final String studentId, type, subject, childId;

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  TextEditingController mathController = TextEditingController();
  TextEditingController arabicController = TextEditingController();
  TextEditingController scienceController = TextEditingController();
  TextEditingController englishController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  String? mathGrade, arabicGrade, englishGrade, scienceGrade, type, subject;

  @override
  void initState() {
    super.initState();
    _getGradesFromFirebase();
  }

  Future<void> _getGradesFromFirebase() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('userslist')
        .doc(auth.currentUser!.uid)
        .get();
    var data = documentSnapshot.data();
    setState(() {
      mathGrade = data!['mathGrades'][0];
      arabicGrade = data['arabicGrades'][0];
      scienceGrade = data['scienceGrades'][0];
      englishGrade = data['englishGrades'][0];
      type = data['type'];
      subject = data['subject'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100.h,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          title: Column(
            children: [
              Image.asset(
                "assets/images/EARLYED.png",
                width: 150.w,
                height: 100.h,
                fit: BoxFit.fill,
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            alignment: Alignment.center,
            child: Text(
              "GRADES",
              style: TextStyle(
                fontSize: 40.h,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (type == 'ad' || type == 'te') {
                if (type != 'te' || subject == 'math') {
                  showDialog(
                    context: context,
                    builder: (_) => Form(
                      key: formKey,
                      child: AlertDialog(
                        contentPadding: EdgeInsets.only(
                            left: 24.w, right: 24.w, top: 20.h, bottom: 10.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(width: 7.w),
                          const Text('Edit Grade')
                        ]),
                        content: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: mathController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'Math Grade'),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'cancel',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                MyDataBase.updateGrades(
                                    widget.studentId,
                                    'mathGrades',
                                    [mathController.text.trim().toString()]);
                                mathGrade =
                                    mathController.text.trim().toString();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setStringList('mathGrades',
                                    [mathController.text.trim().toString()]);
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            child: const Text(
                              'save',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                width: 280.w,
                height: 80.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: Colors.blueAccent)),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection('userslist')
                      .doc(widget.type == 'st'
                          ? widget.studentId
                          : widget.childId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    /*if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }*/
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('No data found'));
                    }

                    var data = snapshot.data!;
                    return ListView.builder(
                      itemBuilder: (buildContext, index) {
                        return Text("Math   ${data['mathGrades'][0]}/50",
                            style:
                                TextStyle(fontSize: 35.h, color: Colors.black));
                      },
                      itemCount: data['mathGrades'].length,
                    );
                  },
                )),
          ),
          GestureDetector(
            onTap: () {
              if (type == 'ad' || type == 'te') {
                if (type != 'te' || subject == 'arabic') {
                  showDialog(
                    context: context,
                    builder: (_) => Form(
                      key: formKey,
                      child: AlertDialog(
                        contentPadding: EdgeInsets.only(
                            left: 24.w, right: 24.w, top: 20.h, bottom: 10.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(width: 7.w),
                          const Text('Edit Grade')
                        ]),
                        content: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: arabicController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'Arabic Grade'),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'cancel',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                MyDataBase.updateGrades(
                                    widget.studentId,
                                    'arabicGrades',
                                    [arabicController.text.trim().toString()]);
                                englishGrade =
                                    arabicController.text.trim().toString();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setStringList('arabicGrades',
                                    [arabicController.text.trim().toString()]);
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            child: const Text(
                              'save',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                width: 280.w,
                height: 80.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: Colors.blueAccent)),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection('userslist')
                      .doc(widget.type == 'st'
                          ? widget.studentId
                          : widget.childId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    /*if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }*/
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('No data found'));
                    }

                    var data = snapshot.data!;
                    return ListView.builder(
                      itemBuilder: (buildContext, index) {
                        return Text("Arabic ${data['arabicGrades'][0]}/50",
                            style:
                                TextStyle(fontSize: 35.h, color: Colors.black));
                      },
                      itemCount: data['arabicGrades'].length,
                    );
                  },
                )),
          ),
          GestureDetector(
            onTap: () {
              if (type == 'ad' || type == 'te') {
                if (type != 'te' || subject == 'science') {
                  showDialog(
                    context: context,
                    builder: (_) => Form(
                      key: formKey,
                      child: AlertDialog(
                        contentPadding: EdgeInsets.only(
                            left: 24.w, right: 24.w, top: 20.h, bottom: 10.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(width: 7.w),
                          const Text('Edit Grade')
                        ]),
                        content: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: scienceController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'Science Grade'),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'cancel',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                MyDataBase.updateGrades(
                                    widget.studentId,
                                    'scienceGrades',
                                    [scienceController.text.trim().toString()]);
                                scienceGrade =
                                    scienceController.text.trim().toString();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setStringList('scienceGrades',
                                    [scienceController.text.trim().toString()]);
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            child: const Text(
                              'save',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                width: 280.w,
                height: 80.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: Colors.blueAccent)),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection('userslist')
                      .doc(widget.type == 'st'
                          ? widget.studentId
                          : widget.childId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    /*if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }*/
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('No data found'));
                    }

                    var data = snapshot.data!;
                    return ListView.builder(
                      itemBuilder: (buildContext, index) {
                        return Text("Science ${data['scienceGrades'][0]}/50",
                            style:
                                TextStyle(fontSize: 30.h, color: Colors.black));
                      },
                      itemCount: data['scienceGrades'].length,
                    );
                  },
                )),
          ),
          GestureDetector(
            onTap: () {
              if (type == 'ad' || type == 'te') {
                if (type != 'te' || subject == 'english') {
                  showDialog(
                    context: context,
                    builder: (_) => Form(
                      key: formKey,
                      child: AlertDialog(
                        contentPadding: EdgeInsets.only(
                            left: 24.w, right: 24.w, top: 20.h, bottom: 10.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(width: 7.w),
                          const Text('Edit Grade')
                        ]),
                        content: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: englishController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'english Grade'),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'cancel',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                MyDataBase.updateGrades(
                                    widget.studentId,
                                    'englishGrades',
                                    [englishController.text.trim().toString()]);
                                englishGrade =
                                    englishController.text.trim().toString();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setStringList('englishGrades',
                                    [englishController.text.trim().toString()]);
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            child: const Text(
                              'save',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                width: 280.w,
                height: 80.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: Colors.blueAccent)),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection('userslist')
                      .doc(widget.type == 'st'
                          ? widget.studentId
                          : widget.childId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    /*if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }*/
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('No data found'));
                    }

                    var data = snapshot.data!;
                    return ListView.builder(
                      itemBuilder: (buildContext, index) {
                        return Text("English ${data['englishGrades'][0]}/50",
                            style:
                                TextStyle(fontSize: 32.h, color: Colors.black));
                      },
                      itemCount: data['englishGrades'].length,
                    );
                  },
                )),
          ),
          const Spacer(),
          // Row(
          //   children: [
          //     IconButton(
          //       style: ButtonStyle(iconSize: MaterialStateProperty.all(60)),
          //       onPressed: () {},
          //       icon: const Icon(Icons.message_sharp),
          //       alignment: Alignment.bottomLeft,
          //     ),
          //     const Spacer(),
          //     IconButton(
          //       style: ButtonStyle(iconSize: MaterialStateProperty.all(60)),
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const HomeScreen(),
          //             ));
          //       },
          //       icon: const Icon(Icons.arrow_circle_right_sharp),
          //       alignment: Alignment.bottomRight,
          //       iconSize: 60,
          //     ),
          //   ],
          // )
        ]));
  }
}
