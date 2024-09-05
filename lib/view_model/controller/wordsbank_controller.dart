import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../apis/api_call.dart';
import '../../utils/preference.dart';

class WordsbankController extends GetxController {
  // Observable list to store word bank data
  var wordBankList = <dynamic>[].obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController footnoteController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    getWordsbankList(); // Fetch the word bank list when the controller is initialized
  }

  @override
  void onReady() {
    super.onReady();
    // Fetch word bank list every time the screen is rendered
    getWordsbankList();
  }

  // Method to show loader
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

  void getWordsbankList() async {
    // showLoader();
    try {
      int? userId = await Preference.getInt('userId', 1);
      var res = await ApiCall().getWordsBank(userId);
      hideLoader();
      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        if (body['status'] == true || body['status'] == "true") {
          wordBankList.value = body['data'];
        } else {
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      // Handle network error
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }
}
