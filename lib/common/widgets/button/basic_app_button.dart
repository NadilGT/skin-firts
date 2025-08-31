import 'package:flutter/material.dart';
import 'package:skin_firts/core/constants/color_manager.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? textColor;
  final String title;
  final double? height;
  const BasicAppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.bgColor, 
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(207, height ?? 45),
        backgroundColor: bgColor ?? AppColors.primaryColor
      ),
      child: Text(title, style: TextStyle(color: textColor ?? Colors.white)),
    );
  }
}