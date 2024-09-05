import 'dart:async';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';

import '../../utils/preference.dart';

class SplashServices {
  void islogin() async {
    String? token = await Preference.getString('token', "");

    print("token========>$token");
    Timer(const Duration(seconds: 3), () {
      if (token != null && token.isNotEmpty) {
        Get.offAndToNamed(RouteName.homeScreen);
      } else {
        Get.offAndToNamed(RouteName.loginScreen);
      }
    });
  }
}
