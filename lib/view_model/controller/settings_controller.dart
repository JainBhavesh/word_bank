import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

import '../../utils/preference.dart';

class SettingsController extends GetxController {
  var errorMessage = ''.obs;
  var getSettingData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getSettingHandler(); // Fetch settings when the controller initializes
  }

  void showLoader() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  void hideLoader() {
    if (Get.isDialogOpen!) {
      Get.back(); // Close the loader
    }
  }

  // Fetch current settings from API and update getSettingData
  void getSettingHandler() async {
    try {
      var res = await ApiCall().getSettingApi();
      if (res.statusCode == 200) {
        hideLoader();
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          // Populate getSettingData with data from the API response
          getSettingData.assignAll(body['data']);
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
      print('Network error: $e');
    } finally {
      hideLoader();
    }
  }

  // Method to update settings via API
  Future<void> updateSetting() async {
    // Create requestBody from dynamically updated getSettingData
    var requestBody = {
      "sound_effect": getSettingData['sound_effect'] ?? "off",
      "music_effect": getSettingData['music_effect'] ?? "off",
      "english_level": getSettingData['english_level'] ?? "starter",
      "ai_level": getSettingData['ai_level'] ?? "encouraging"
    };
    print('requestBody===>${requestBody}');
    try {
      showLoader();
      int? userId =
          await Preference.getInt('userId', 1); // Example user ID retrieval
      var res = await ApiCall().updateSettingApi(requestBody, userId);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        hideLoader();
        if (body['status'] == true || body['status'] == "true") {
          Get.snackbar('Success', body["message"],
              snackPosition: SnackPosition.TOP);
        } else {
          errorMessage.value = body['message'] ?? 'Unknown error occurred';
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        hideLoader();
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
    } catch (SocketException) {
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }
}
