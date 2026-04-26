import 'package:flutter/material.dart';

class ResponsiveScreen {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  /// Ekran genişliğine göre orantılı boyut döndürür (Tasarım genişliği varsayılan: 375.0)
  static double w(double width) {
    if (screenWidth == 0) return width;
    return width * (screenWidth / 375.0);
  }

  /// Ekran yüksekliğine göre orantılı boyut döndürür (Tasarım yüksekliği varsayılan: 812.0)
  static double h(double height) {
    if (screenHeight == 0) return height;
    return height * (screenHeight / 812.0);
  }

  static bool isTablet() {
    return screenWidth > 600;
  }
}
