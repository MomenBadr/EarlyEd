import 'package:early_ed/widgets/level.dart';
import 'package:flutter/material.dart';

class SelectLevelScreen extends StatelessWidget {
  const SelectLevelScreen({super.key, required this.isGrades});
  final bool isGrades;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Level')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Level(level: 1, isGrades: isGrades),
          Level(level: 2, isGrades: isGrades),
          Level(level: 3, isGrades: isGrades),
          Level(level: 4, isGrades: isGrades),
          Level(level: 5, isGrades: isGrades),
          Level(level: 6, isGrades: isGrades)
        ],
      ),
    );
  }
}
