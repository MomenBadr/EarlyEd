import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/Presentation/attendance/attendance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen(
      {super.key, this.studentId, required this.type, required this.childId});

  final studentId;
  final String type, childId;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          title: Column(
            children: [
              Image.asset(
                "assets/images/EARLYED.png",
                width: 150,
                height: 100,
                fit: BoxFit.fill,
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Attendance",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                    stream: firestore
                        .collection('userslist')
                        .doc(widget.childId.trim() != null
                            ? widget.studentId ?? auth.currentUser!.uid
                            : widget.childId)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                          return AttendanceData(
                            day: Jiffy.now()
                                .subtract(
                                    days: data['weekAtt'].length -
                                        data['weekAtt'].length +
                                        index)
                                .E,
                            date: Jiffy.now()
                                .subtract(
                                    days: data['weekAtt'].length -
                                        data['weekAtt'].length +
                                        index)
                                .MMMd,
                            present: data['weekAtt'][index] == '1',
                            attendance: data['weekAtt']
                                .map((item) => item.toString())
                                .toList(),
                            index: index,
                            studentId: widget.studentId,
                            type: widget.type,
                          );
                        },
                        itemCount: data['weekAtt'].length,
                      );
                    },
                  ))
                ])));
  }
}
