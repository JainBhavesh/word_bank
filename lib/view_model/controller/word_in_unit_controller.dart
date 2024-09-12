import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';
import 'package:word_bank/view/home_screen.dart';

class WordInUnitController extends GetxController {
  Future<void> createUnit({required int count, required int wordbankId}) async {
    _showLoader();

    var requestBody = {"count": count, "wordbank_id": wordbankId};

    debugPrint('----requestBody------->>>>${requestBody.toString()}');

    try {
      var response = await ApiCall().addWordsUnits(requestBody);
      var responseBody = jsonDecode(response.body);
      debugPrint("responseBody addWordsUnits====>$responseBody");
      if (response.statusCode == 200) {
        if (responseBody['status'] == true || responseBody['status'] == "true") {
          await _hideLoader();

          Get.snackbar('Success', responseBody["message"], snackPosition: SnackPosition.TOP);
          Get.offAll(() => const HomeScreen());
        } else {
          await _hideLoader();
          Get.snackbar('Error', responseBody['message'] ?? 'Unknown error occurred', snackPosition: SnackPosition.TOP);
        }
      } else {
        await _hideLoader();
        Get.snackbar('Error', responseBody["message"] ?? 'Failed to add word to wordbank', snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      await _hideLoader();
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.TOP);
    }
  }

  void _showLoader() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  // Hide loader after the operation
  Future<void> _hideLoader() async {
    if (Get.isDialogOpen!) {
      Get.back(); // Close the loading dialog
    }
    return Future.delayed(const Duration(milliseconds: 300));
  }
}
