import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

import '../../utils/preference.dart';

class BottomController extends GetxController {
  var editNickName = ''.obs;
  var password = ''.obs;
  var confirnPassword = ''.obs;
  var errorMessage = ''.obs;
  var userData = {}.obs;
  var getAchievementData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    getAchievementHandler();
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

  void getUserData() async {
    // showLoader();
    try {
      var res = await ApiCall().getUserData();
      if (res.statusCode == 200) {
        hideLoader();
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          userData.assignAll(body['data']);
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

  void getAchievementHandler() async {
    // showLoader();
    try {
      var res = await ApiCall().getAchievementApi();
      if (res.statusCode == 200) {
        hideLoader();
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          getAchievementData.assignAll(body['data']);
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

  Future<void> editNickNameHandler() async {
    // Show loader before making the API call
    int? userId = await Preference.getInt('userId', 1);
    var requestBody = {
      "name": editNickName.value,
    };

    try {
      showLoader();
      var res = await ApiCall().editUserApi(requestBody, userId);
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
      // ignore: non_constant_identifier_names
    } catch (SocketException) {
      // Handle network error
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> changePasswordHandler() async {
    // Show loader before making the API call
    var requestBody = {
      "password": password.value,
      "confirm_password": confirnPassword.value
    };

    try {
      showLoader();
      var res = await ApiCall().changePassword(requestBody);
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
      // ignore: non_constant_identifier_names
    } catch (SocketException) {
      // Handle network error
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> logout() async {
    showLoader();
    try {
      var res = await ApiCall().logout();
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        hideLoader();
        Get.snackbar('Success', body["message"],
            snackPosition: SnackPosition.TOP);
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
