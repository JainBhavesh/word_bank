import 'package:flutter/material.dart';

class ResponsiveUtil {
  static double designWidth = 375;
  static double designHeight = 812;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double scaleWidth(BuildContext context, double val) {
    return (screenWidth(context) * val) / designWidth;
  }

  static double scaleHeight(BuildContext context, double val) {
    return (screenHeight(context) * val) / designHeight;
  }

  static double scale(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return screenWidth / designWidth < screenHeight / designHeight
        ? screenWidth / designWidth
        : screenHeight / designHeight;
  }

  static double moderateScale(BuildContext context, double size,
      {double factor = 1}) {
    return size + (scaleWidth(context, size) - size) * factor;
  }

  static double scaledSize(BuildContext context, double size) {
    return (size * scale(context)).ceil().toDouble();
  }
}
