import 'package:flutter/material.dart';
import '../../../core/constants/color_manager.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textFieldBgColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintText: 'Search...',
        hintStyle: TextStyle(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        // Left icon (hamburger menu)
        prefixIcon: Container(
          padding: EdgeInsets.all(12),
          child: Icon(
            Icons.menu,
            color: AppColors.hintTextColor,
            size: 24,
          ),
        ),
        // Right icon (search)
        suffixIcon: Container(
          padding: EdgeInsets.all(12),
          child: Icon(
            Icons.search,
            color: AppColors.hintTextColor,
            size: 24,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: AppColors.textFieldBgColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
      ),
    );
  }
}