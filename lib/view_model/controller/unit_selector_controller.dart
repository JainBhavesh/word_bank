import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

class UnitSelectorController extends GetxController {
  var isLoading = false.obs;
  var dateList = <dynamic>[].obs;
  int id = 0;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    getWordsList();
  }

  void getWordsList() async {
    isLoading(true);
    try {
      print("id---------->$id");
      var res = await ApiCall().getWordsUnits(id);

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          // debugPrint('--body----->${body.toString()}');
          dateList.value = body['data'];
          // debugPrint('--body----->${dateList.toString()}');
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
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
      print('Network error: $e'); // Debugging
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateWordsUnit(int unitId, String selectedDate) async {
    isLoading(true); // Show loader
    try {
      var requestBody = {"target_date": selectedDate};
      var res = await ApiCall().updateWordBankUnits(unitId, requestBody);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        if (body['status'] == true || body['status'] == "true") {
          dateList.value = body['data'] ?? [];
          Get.snackbar('Success', body['message'] ?? 'Operation successful',
              snackPosition: SnackPosition.TOP);
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
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
      print('Network error: $e');
    } finally {
      isLoading(false); // Hide loader
    }
  }

  void sortDateList() {
    dateList.sort((a, b) {
      DateTime? dateA = parseDate(a['target_date']);
      DateTime? dateB = parseDate(b['target_date']);

      if (dateA != null && dateA.isBefore(DateTime.now())) {
        return -1;
      } else if (dateB != null && dateB.isBefore(DateTime.now())) {
        return 1;
      }

      if (dateA != null && dateA.isAfter(DateTime.now())) {
        return -1;
      } else if (dateB != null && dateB.isAfter(DateTime.now())) {
        return 1;
      }

      return 0;
    });
  }

  DateTime? parseDate(String? date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }
}
