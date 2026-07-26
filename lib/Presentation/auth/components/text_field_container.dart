import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor == Colors.white
            ? const Color(0xFFF1E6FF)
            : Colors.black38,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
