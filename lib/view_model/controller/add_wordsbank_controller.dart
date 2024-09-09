import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';
import 'package:word_bank/view_model/controller/wordsbank_controller.dart';
import '../../apis/api_call.dart';

class AddWordbankController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController footnoteController = TextEditingController();
  final WordsbankController wordsbankController =
      Get.find<WordsbankController>();

  Future<void> createWordbank() async {
    String name = nameController.text.trim();
    String footnote = footnoteController.text.trim();

    if (name.isEmpty || footnote.isEmpty) {
      Get.snackbar('Error', 'Name and footnote cannot be empty',
          snackPosition: SnackPosition.TOP);
      return;
    }

    _showLoader();

    var requestBody = {"name": name, "footnote": footnote, "type": "personal"};

    try {
      var response = await ApiCall().addWordsBank(requestBody);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          await _hideLoader(); // Await hiding the loader
          wordsbankController.getPersonalWordsbankList();
          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);

          // Alternative navigation using Get.off() to ensure navigation works
          print("Navigating back now...");
          Get.offNamed(RouteName
              .personalWordBankScreen); // Replace with the actual route of the previous screen
        } else {
          await _hideLoader(); // Hide loader on failure
          Get.snackbar(
              'Error', responseBody['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        await _hideLoader(); // Hide loader if status code is not 200
        Get.snackbar(
            'Error', responseBody["message"] ?? 'Failed to create wordbank',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      await _hideLoader(); // Hide loader on exception
      if (e is SocketException) {
        Get.snackbar('Network Error',
            'Failed to connect to the server. Please check your internet connection.',
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Error', 'Something went wrong: $e',
            snackPosition: SnackPosition.TOP);
      }
    }
  }

  Future<void> renameWordbank({required int id}) async {
    String name = nameController.text.trim();
    String footnote = footnoteController.text.trim();

    _showLoader();

    var requestBody = {"name": name, "footnote": footnote, "type": "personal"};

    try {
      var response = await ApiCall().updateWordBank(id, requestBody);

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("response rename is-->$responseBody");

        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          await _hideLoader(); // Await hiding the loader

          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);
          wordsbankController.getPersonalWordsbankList();

          // Navigate back to the previous screen after success
          print("Navigating back now...");
          Get.offNamed(RouteName.personalWordBankScreen);
        } else {
          await _hideLoader(); // Hide loader on failure
          Get.snackbar(
              'Error', responseBody['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        await _hideLoader(); // Hide loader if status code is not 200
        Get.snackbar(
            'Error', responseBody["message"] ?? 'Failed to rename wordbank',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      await _hideLoader(); // Hide loader on exception
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> deleteWordbank({required int id}) async {
    _showLoader();

    try {
      var response = await ApiCall().deleteWordsBank(id);

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("response delete is-->$responseBody");

        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          await _hideLoader(); // Await hiding the loader
          wordsbankController.getPersonalWordsbankList();

          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);

          // Navigate back to the previous screen after success
          Get.back();
          wordsbankController.getPersonalWordsbankList();
        } else {
          await _hideLoader(); // Hide loader on failure
          Get.snackbar(
              'Error', responseBody['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        await _hideLoader(); // Hide loader if status code is not 200
        Get.snackbar(
            'Error', responseBody["message"] ?? 'Failed to delete wordbank',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      await _hideLoader(); // Hide loader on exception
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  void _showLoader() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    print("Loader shown");
  }

  Future<void> _hideLoader() async {
    if (Get.isDialogOpen!) {
      print("Closing loader...");
      Get.back(); // Close the loading dialog
    }
    return Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    nameController.dispose();
    footnoteController.dispose();
    super.onClose();
  }
}
