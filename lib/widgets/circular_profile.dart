import 'package:flutter/material.dart';

class CircularProfile extends StatelessWidget {
  const CircularProfile({
    super.key,
    required this.image,
    this.backgroundColor,
    this.innerBorderColor,
    this.borderThickness,
    this.radius = 40,
    this.onTap,
    this.showShadow = true,
    this.showInnerBorder = true,
    this.customShadow,
  });
  final ImageProvider<Object> image;
  final Color? backgroundColor;
  final Color? innerBorderColor;
  final double? borderThickness;
  final double radius;
  final VoidCallback? onTap;
  final bool showShadow;
  final bool showInnerBorder;
  final List<BoxShadow>? customShadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: showShadow
              ? customShadow ??
                  [
                    BoxShadow(
                      color: backgroundColor ??
                          Theme.of(context).primaryColor.withOpacity(0.5),
                      spreadRadius: radius * 0.1,
                      blurRadius: radius * 0.3,
                      offset: const Offset(0, 0),
                    ),
                  ]
              : null,
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
        child: showInnerBorder
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: innerBorderColor ?? Colors.white.withOpacity(0.5),
                    width: borderThickness ?? radius * 0.1,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
