import 'dart:async';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';

class SplashServices {
  void islogin() {
    Timer(const Duration(seconds: 3), () {
      Get.offAndToNamed(RouteName.homeScreen);
    });
  }
}
