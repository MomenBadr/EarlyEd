import 'package:cached_network_image/cached_network_image.dart';
import 'package:early_ed/model/user_model.dart';
import 'package:early_ed/Presentation/attendance/attendance_screen.dart';
import 'package:early_ed/Presentation/grades/grades_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Student extends StatelessWidget {
  const Student({super.key, required this.student, required this.isGrades});
  final UserModel student;
  final bool isGrades;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => isGrades
                      ? GradesScreen(
                          math: student.mathGrades
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              [],
                          arabic: student.arabicGrades
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              [],
                          english: student.englishGrades
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              [],
                          science: student.scienceGrades
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              [],
                          studentId: student.userId!,
                          type: student.type!,
                          subject: student.subject!,
                          childId: student.childId ?? '')
                      : AttendanceScreen(
                          studentId: student.userId,
                          type: 'ad',
                          childId: student.childId ?? '')));
        },
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
                fit: BoxFit.contain,
                height: 50.h,
                width: 50.w,
                imageUrl: student.userImageUrl ??
                    'https://s.france24.com/media/display/e6279b3c-db08-11ee-b7f5-005056bf30b7/w:1024/p:16x9/news_en_1920x1080.jpg',
                // errorWidget: (context, url, error) => const CustomImage(imagePath: AppAssets.errorImage),
                // placeholder: (context, url) => const CustomImage(imagePath: AppAssets.placeholder),
                progressIndicatorBuilder: (context, url, progress) => SizedBox(
                    width: 50.w,
                    child: const Center(child: CircularProgressIndicator())))),
        title: Text(student.userName ?? ''),
        subtitle: Text(student.parentOrChildName ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
