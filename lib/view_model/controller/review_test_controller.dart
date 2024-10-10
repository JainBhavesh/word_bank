import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

class ReviewTestController extends GetxController {
  TextEditingController chineseController = TextEditingController();
  TextEditingController englishController = TextEditingController();
  var isLoading = false.obs;
  var examTypeList = <Map<String, dynamic>>[].obs;
  var examData = [].obs;
  var easyExamData = [].obs;
  var reviewData = [].obs;
  var matchingModeData = [].obs;
  var aiData = Rx<Map<String, dynamic>>({});
  var gameResultData = {}.obs;
  var wordsUnitList = <dynamic>[].obs;
  var total = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void getExamTypeList({required int unit_id}) async {
    isLoading(true);

    try {
      var res = await ApiCall().getExamType(unit_id);
      if (res.statusCode == 200) {
        isLoading(false);
        var body = json.decode(res.body) as Map<String, dynamic>;

        if (body['status'] == true || body['status'] == "true") {
          var data = body['data'] as Map<String, dynamic>;
          total.value = data['total'] ?? 0;
          // Filter out 'total' from data
          var examData = data.entries
              .where((entry) => entry.key != 'total')
              .map((entry) => entry.value as Map<String, dynamic>)
              .toList();

          examTypeList.value = examData;
        } else {
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        isLoading(false);
        var errorResponse = json.decode(res.body) as Map<String, dynamic>;
        Get.snackbar(
            'Error', errorResponse['message'] ?? 'Unknown error occurred',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  // void getExamTypeList({required int unit_id}) async {
  //   isLoading(true);

  //   try {
  //     var res = await ApiCall().getExamType(unit_id);
  //     if (res.statusCode == 200) {
  //       isLoading(false);
  //       var body = json.decode(res.body) as Map<String, dynamic>;
  //       print("getExamTypeList res===>$body");

  //       if (body['status'] == true || body['status'] == "true") {
  //         var data = body['data'] as List<dynamic>;
  //         examTypeList.value =
  //             data.map((item) => item as Map<String, dynamic>).toList();
  //       } else {
  //         Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
  //             snackPosition: SnackPosition.TOP);
  //       }
  //     } else {
  //       isLoading(false);
  //       var errorResponse = json.decode(res.body) as Map<String, dynamic>;
  //       Get.snackbar(
  //           'Error', errorResponse['message'] ?? 'Unknown error occurred',
  //           snackPosition: SnackPosition.TOP);
  //     }
  //   } catch (e) {
  //     isLoading(false);
  //     Get.snackbar('Network Error',
  //         'Unable to reach the server. Please check your internet connection.',
  //         snackPosition: SnackPosition.TOP);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  void getUnitWordsList({required int unit_id}) async {
    isLoading(true);

    try {
      var res = await ApiCall().getUnitWords(unit_id);

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print("getUnitWordsList res==>$body");

        if (body['status'] == true || body['status'] == "true") {
          // Directly assigning body['data'] as it contains the list of words
          wordsUnitList.value = body['data']
              .reversed
              .toList(); // Assuming you want to reverse the list
        } else {
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        var errorResponse = json.decode(res.body) as Map<String, dynamic>;
        Get.snackbar(
            'Error', errorResponse['message'] ?? 'Unknown error occurred',
            snackPosition: SnackPosition.TOP);
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

  Future<void> exam({required int unit_id, required int exam_id}) async {
    isLoading(true); // Start loading indicator
    try {
      var res = await ApiCall().getExam(unit_id, exam_id);

      if (res.statusCode == 200) {
        isLoading(false);
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          if (exam_id == 1) {
            easyExamData.value = body['data'];
          }
          if (exam_id == 2) {
            examData.value = body['data']; // Store the exam data here
          }
          if (exam_id == 3) {
            matchingModeData.value = body['data']; // Store the exam data here
          }
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
      isLoading(false); // Stop loading indicator
    }
  }

  // ignore: non_constant_identifier_names
  void getReview({required int unit_id}) async {
    isLoading(true);
    try {
      var res = await ApiCall().getReview(unit_id);

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          reviewData.value = body['data']; // Store the exam data here
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

  // ignore: non_constant_identifier_names
  Future aiDataGenerate({required aiBody}) async {
    isLoading(true);
    try {
      var res = await ApiCall().aiDataHandler(aiBody);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        if (body is List && body.isNotEmpty) {
          aiData.value = Map<String, dynamic>.from(body[0]);
        } else {
          Get.snackbar('Error', 'No data found or invalid response format',
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

  Future<void> gameResult({
    required int unit_id,
    required int exam_id,
    int? notification_id,
  }) async {
    // Create the request body with required fields
    var requestBody = {
      "unit_id": unit_id,
      "exam_id": exam_id,
    };

    // Add notification_id if it's provided and not equal to 0
    if (notification_id != null && notification_id != 0) {
      requestBody["notification_id"] = notification_id;
    }

    isLoading(true);
    try {
      var res = await ApiCall().gameResult(requestBody);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        if (body['status'] == true || body['status'] == "true") {
          // Assign the data map to gameResultData using assignAll to preserve reactivity
          gameResultData.assignAll(body['data']);
          getExamTypeList(unit_id: unit_id);
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

  Future<void> editWord({
    required int word_id,
    required List<String> selectedWordTypes,
    required String chineseName,
    required String englishName,
  }) async {
    if (chineseName.isEmpty || englishName.isEmpty) {
      Get.snackbar('Error', 'Both Chinese and English fields are required',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading(true);

    var requestBody = {
      "chinese_name": chineseName,
      "english_name": englishName,
      "type": selectedWordTypes,
    };

    try {
      var response = await ApiCall().updateWord(word_id, requestBody);

      print('Raw response body: ${response.body}');

      if (response.body.isNotEmpty) {
        try {
          var responseBody = jsonDecode(response.body);
          print('Decoded response body: $responseBody');

          if (response.statusCode == 200) {
            if (responseBody['status'] == true ||
                responseBody['status'] == "true") {
              print("word_id=========================>${word_id}");
              isLoading(false);

              chineseController.clear();
              englishController.clear();
              Get.back();

              Get.snackbar('Success', responseBody["message"],
                  snackPosition: SnackPosition.TOP);
            } else {
              print('Unexpected status in response: ${responseBody['status']}');
              isLoading(false);
              Get.snackbar(
                  'Error', responseBody['message'] ?? 'Unknown error occurred',
                  snackPosition: SnackPosition.TOP);
            }
          } else {
            print('Unexpected status code: ${response.statusCode}');
            isLoading(false);
            Get.snackbar('Error', 'Unexpected error occurred',
                snackPosition: SnackPosition.TOP);
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          isLoading(false);
          Get.snackbar('Error', 'Invalid response format: $e',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        print('Response body is empty');
        isLoading(false);
        Get.snackbar('Error', 'The response from the server was empty',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      isLoading(false);
      print('Exception occurred: $e');
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> deletWord({required int id}) async {
    isLoading(true);

    try {
      // Make the API call to delete the word
      var response = await ApiCall().deleteWord(id);
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody['status'] == true ||
            responseBody['status'] == "true") {
          // Successfully deleted
          isLoading(false);

          Get.snackbar('Success', responseBody["message"],
              snackPosition: SnackPosition.TOP);
        }
      } else {
        // Handle failure
        isLoading(false);
        Get.snackbar('Error',
            responseBody['message'] ?? 'Failed to delete word from wordbank',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      // Handle unexpected errors
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP);
    }
  }
}
