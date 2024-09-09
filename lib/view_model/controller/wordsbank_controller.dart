import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../apis/api_call.dart';
import '../../utils/preference.dart';

class WordsbankController extends GetxController {
  var personalwordBankList = <dynamic>[].obs;
  var buildinwordBankList = <dynamic>[].obs;
  var isLoading = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController footnoteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    String? type =
        Get.parameters['type']; // Check if it's personal or built-in word bank
    if (type == 'builtin') {
      getBuiltinWordsbankList();
    } else {
      getPersonalWordsbankList();
    }
  }

  @override
  void onReady() {
    super.onReady();
    getPersonalWordsbankList();
  }

  void getPersonalWordsbankList() async {
    isLoading(true);
    try {
      int? userId = await Preference.getInt('userId', 1);
      var res = await ApiCall().getWordsBank(userId);
      isLoading(false);

      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        if (body['status'] == true || body['status'] == "true") {
          personalwordBankList.value = body['data'].reversed.toList();
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
      isLoading(false);
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }

  void getBuiltinWordsbankList() async {
    isLoading(true);
    try {
      var res = await ApiCall().getBuiltInWordsBank();
      isLoading(false);

      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        if (body['status'] == true || body['status'] == "true") {
          buildinwordBankList.value = body['data'].reversed.toList();
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
      isLoading(false);
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }
}
