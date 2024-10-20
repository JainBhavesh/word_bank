import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

class AboutDataController extends GetxController {
  var aboutData = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAbout();
  }

  void showLoader() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  // Method to hide loader
  void hideLoader() {
    if (Get.isDialogOpen!) {
      Get.back(); // Close the loader
    }
  }

  void getAbout() async {
    // showLoader();
    try {
      var res = await ApiCall().getAboutData();
      if (res.statusCode == 200) {
        hideLoader();
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          aboutData.value = body['data'] ?? '';
        } else {
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        hideLoader();
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
      print('Network error: $e'); // Debugging
    } finally {
      hideLoader();
    }
  }
}
