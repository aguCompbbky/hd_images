import 'package:flutter/material.dart';
import 'package:hd_images/core/responsive_screen/responsive_screen.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField({
    required this.hintText, required this.prefixIcon, super.key,
    this.controller,
    this.isPassword = false,
  });
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveScreen.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Theme.of(context).colorScheme.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveScreen.w(20),
            vertical: ResponsiveScreen.h(16),
          ),
        ),
      ),
    );
  }
}
