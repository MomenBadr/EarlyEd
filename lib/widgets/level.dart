import 'package:early_ed/Presentation/select_screens/studentsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Level extends StatelessWidget {
  const Level({super.key, required this.level, required this.isGrades});
  final int level;
  final bool isGrades;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StudentsListScreen(
                      level: level,
                      isGrades: isGrades,
                    )));
      },
      child: SizedBox(
        height: 70.h,
        child: Card(
          child: Center(
            child: Text(level.toString()),
          ),
        ),
      ),
    );
  }
}
