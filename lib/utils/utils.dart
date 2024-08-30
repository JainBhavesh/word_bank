import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static void fieldFocusedChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static snackBar(String title, String message) {
    Get.snackbar(title, message);
  }
}
