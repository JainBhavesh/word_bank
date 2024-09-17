import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/view_model/controller/word_controller.dart';
import '../../apis/api_call.dart';

class AddWordToWordbankbankController extends GetxController {
  TextEditingController chineseController = TextEditingController();
  TextEditingController englishController = TextEditingController();

  int wordbankId = 0;
  int updateBankId = 0;

  // Word Types with default unchecked
  final List<String> wordTypes =
      ['noun', 'verb', 'prep', 'conj', 'adj', 'adv'].obs;
  late Map<String, bool> selectedTypes = {
    'noun': false,
    'verb': false,
    'prep': false,
    'conj': false,
    'adj': false,
    'adv': false,
  }.obs;

  // List to store added words temporarily
  final List<Map<String, dynamic>> words = [];
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

    debugPrint('----requestBody------->>>>${requestBody.toString()}');

    try {
      var response =
          await ApiCall().addWordToWordksbank(wordbankId, requestBody);
      var responseBody = jsonDecode(response.body);
      debugPrint("responseBody addWordToWordksbank====>$responseBody");
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

          // Clear the text fields and reset selected types after successfully adding a word
          chineseController.clear();
          englishController.clear();

          // Reset selectedTypes map to all false
          selectedTypes.updateAll((key, value) =>
              false); // This will reset all selected types to false

          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);
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

  Future<void> setDataToUpdate({required int id}) async {
    String chineseName = chineseController.text.trim();
    String englishName = englishController.text.trim();

    wordbankId = id;
    update();
  }

  Future<void> editWordToWordbank() async {
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

    print("requestBody requestBody====>$requestBody");

    try {
      var response = await ApiCall().updateWord(wordbankId, requestBody);
      var responseBody = jsonDecode(response.body);
      print("responseBody addWordToWordksbank====>$responseBody");
      if (response.statusCode == 200) {
        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          await _hideLoader();
          // Add the word locally for temporary display in UI
          // words.add({"chinese_name": chineseName, "english_name": englishName, "type": selectedWordTypes});

          // Clear the text fields and selections after successfully adding a word
          chineseController.clear();
          englishController.clear();
          selectedTypes.updateAll((key, value) => false);

          Get.find<WordsController>().getWordsList();

          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);
          // Get.offNamed(RouteName.personalWordBankScreen);
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

  Future<void> deletWordToWordbank({required int id}) async {
    _showLoader();

    try {
      // Make the API call to delete the word
      var response = await ApiCall().deleteWord(id);
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          // Successfully deleted
          await _hideLoader();
          Get.find<WordsController>().getWordsList();
          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);
        }
      } else {
        // Handle failure
        await _hideLoader();
        Get.snackbar('Error',
            responseBody['message'] ?? 'Failed to delete word from wordbank',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      // Handle unexpected errors
      await _hideLoader();
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP);
    }
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

  void resetSelectedTypesForEdit(List<String> wordTypes) {
    // Reset all values to false first
    selectedTypes.updateAll((key, value) => false);

    // Set true for the types of the word being edited
    for (var type in wordTypes) {
      if (selectedTypes.containsKey(type)) {
        selectedTypes[type] = true;
      }
    }
  }

  @override
  void onClose() {
    chineseController.dispose();
    englishController.dispose();

    super.onClose();
  }
}
