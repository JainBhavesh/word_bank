import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../apis/api_call.dart';
import '../../routes/routes_name.dart';

class AddWordToWordbankbankController extends GetxController {
  TextEditingController chineseController = TextEditingController();
  TextEditingController englishController = TextEditingController();

  // Word Types with default unchecked
  final List<String> wordTypes = ['noun', 'verb', 'prep', 'conj', 'adj', 'adv'];
  final Map<String, bool> selectedTypes = {
    'noun': false,
    'verb': false,
    'prep': false,
    'conj': false,
    'adj': false,
    'adv': false,
  };

  // List to store added words temporarily
  final List<Map<String, dynamic>> words = [];

  // Add Word to Wordbank (validate and add the word)
  Future<void> addWordToWordbank({required int wordbankId}) async {
    String chineseName = chineseController.text.trim();
    String englishName = englishController.text.trim();

    // Validation: Ensure both Chinese and English fields are not empty
    if (chineseName.isEmpty || englishName.isEmpty) {
      Get.snackbar('Error', 'Both Chinese and English fields are required',
          snackPosition: SnackPosition.TOP);
      return;
    }

    // Collect selected word types
    List<String> selectedWordTypes = selectedTypes.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Validation: Ensure at least one word type is selected
    if (selectedWordTypes.isEmpty) {
      Get.snackbar('Error', 'At least one word type must be selected',
          snackPosition: SnackPosition.TOP);
      return;
    }

    _showLoader();

    var requestBody = {
      "chinese_name": chineseName,
      "english_name": englishName,
      "type": selectedWordTypes,
      "wordbank_id": wordbankId
    };

    try {
      var response =
          await ApiCall().addWordToWordksbank(wordbankId, requestBody);
      var responseBody = jsonDecode(response.body);
      print("responseBody addWordToWordksbank====>$responseBody");
      if (response.statusCode == 200) {
        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          await _hideLoader();

          // Add the word locally for temporary display in UI
          words.add({
            "chinese_name": chineseName,
            "english_name": englishName,
            "type": selectedWordTypes
          });

          // Clear the text fields and selections after successfully adding a word
          chineseController.clear();
          englishController.clear();
          selectedTypes.updateAll((key, value) => false);

          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);
          Get.offNamed(RouteName.personalWordBankScreen);
        } else {
          await _hideLoader();
          Get.snackbar(
              'Error', responseBody['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        await _hideLoader();
        Get.snackbar('Error',
            responseBody["message"] ?? 'Failed to add word to wordbank',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      await _hideLoader();
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  // Delete a word locally (remove it from the list)
  void deleteWordFromUI(int index) {
    words.removeAt(index);
    update(); // To refresh the UI
  }

  // Show loader during async operations
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

  @override
  void onClose() {
    chineseController.dispose();
    englishController.dispose();
    super.onClose();
  }
}
