import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/model/user_model.dart';
import 'package:early_ed/widgets/student.dart';
import 'package:flutter/material.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key, required this.level, required this.isGrades});
  final int level;
  final bool isGrades;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(level.toString()),
      ),
      body: StreamBuilder<QuerySnapshot<UserModel>>(
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('error loading data, try again later'),
            );
          } /*else if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }*/
          List<UserModel> data =
          snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return data.isEmpty
                  ? const Center(
                child: Text('no students'),
              )
                  : Student(student: data[index], isGrades: isGrades,);
            },
            itemCount: data.length,
          );
        },
        stream:
        MyDataBase.listenForStudentsRealTimeUpdatesDependingOnLevel(level),
      )
    );
  }
}
