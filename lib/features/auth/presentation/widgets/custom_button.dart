import 'package:flutter/material.dart';
import 'package:hd_images/core/responsive_screen/responsive_screen.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({
    required this.text, required this.onPressed, super.key,
    this.isOutline = false,
    this.isLoading = false,
    this.icon,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isOutline;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(ResponsiveScreen.w(16)),
      child: Container(
        height: ResponsiveScreen.h(56),
        decoration: BoxDecoration(
          color: isOutline ? Colors.transparent : theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(ResponsiveScreen.w(16)),
          border: isOutline ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
          boxShadow: isOutline ? [] : [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: ResponsiveScreen.w(24),
                height: ResponsiveScreen.w(24),
                child: CircularProgressIndicator(
                  color: isOutline ? theme.colorScheme.primary : Colors.white,
                  strokeWidth: 2,
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, color: isOutline ? theme.colorScheme.primary : Colors.white),
                SizedBox(width: ResponsiveScreen.w(8)),
              ],
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isOutline ? theme.colorScheme.primary : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
