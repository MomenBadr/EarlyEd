import 'package:early_ed/database/my_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceData extends StatelessWidget {
  const AttendanceData(
      {super.key,
      required this.day,
      required this.date,
      required this.present,
      required this.attendance,
      required this.index,
      required this.studentId,
      required this.type});

  final String day, date, studentId, type;
  final bool present;
  final List attendance;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black)),
        width: double.infinity,
        height: 50.h,
        child: Row(children: [
          Text('$day/ $date'),
          const Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      present ? Colors.greenAccent : Colors.redAccent),
              onPressed: () {
                if (type == 'ad' || type == 'te') {
                  attendance[index] = present ? '0' : '1';
                  MyDataBase.updateAttendance(studentId, 'weekAtt', attendance);
                }
              },
              child: Text(present ? 'Present' : "Absent"))
        ]));
  }
}
