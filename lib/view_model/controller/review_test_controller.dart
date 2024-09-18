import 'dart:convert';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

class ReviewTestController extends GetxController {
  var isLoading = false.obs;
  var examTypeList = <Map<String, dynamic>>[].obs;
  var examData = [].obs;
  var easyExamData = [].obs;
  var reviewData = [].obs;
  var matchingModeData = [].obs;
  var aiData = Rx<Map<String, dynamic>>({});
  var gameResultData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getExamTypeList();
  }

  void getExamTypeList() async {
    isLoading(true);

    try {
      var res = await ApiCall().getExamType();
      if (res.statusCode == 200) {
        isLoading(false);
        var body = json.decode(res.body) as Map<String, dynamic>;
        if (body['status'] == true || body['status'] == "true") {
          var data = body['data'] as List<dynamic>;
          examTypeList.value =
              data.map((item) => item as Map<String, dynamic>).toList();
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

  Future<void> exam({required int unit_id, required int exam_id}) async {
    isLoading(true); // Start loading indicator
    try {
      var res = await ApiCall().getExam(unit_id, exam_id);

      if (res.statusCode == 200) {
        isLoading(false);
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          if (exam_id == 1) {
            print("easy------------");

            easyExamData.value = body['data'];
          }
          if (exam_id == 2) {
            print("advance------------");
            examData.value = body['data']; // Store the exam data here
          }
          if (exam_id == 3) {
            print("matching------------");

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

  // void exam({required int unit_id, required int exam_id}) async {
  //   print("unit_id---------------->$unit_id");
  //   print("exam_id---------------->$exam_id");
  //   isLoading(true); // Start loading indicator
  //   try {
  //     var res = await ApiCall().getExam(unit_id, exam_id);

  //     if (res.statusCode == 200) {
  //       var body = json.decode(res.body);
  //       if (body['status'] == true || body['status'] == "true") {
  //         print("question list-->$body");
  //         if (exam_id == 1) {
  //           easyExamData.value = body['data'];
  //         }
  //         if (exam_id == 2) {
  //           examData.value = body['data']; // Store the exam data here
  //         }
  //         if (exam_id == 3) {
  //           matchingModeData.value = body['data']; // Store the exam data here
  //         }
  //       } else {
  //         Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
  //             snackPosition: SnackPosition.TOP);
  //       }
  //     } else {
  //       var errorResponse = json.decode(res.body);
  //       String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
  //       Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
  //     }
  //   } catch (e) {
  //     Get.snackbar('Network Error',
  //         'Unable to reach the server. Please check your internet connection.',
  //         snackPosition: SnackPosition.TOP);
  //     print('Network error: $e'); // Debugging
  //   } finally {
  //     isLoading(false); // Stop loading indicator
  //   }
  // }

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
  void aiDataGenerate({required String word}) async {
    print("word=====>$word");
    isLoading(true);
    try {
      var res = await ApiCall().aiDataHandler(word);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        if (body['status'] == true || body['status'] == "true") {
          print("body=====>$body");
          // Assign the data map to aiData
          aiData.value = Map<String, dynamic>.from(body['data']);
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

  void gameResult({required int unit_id, required int exam_id}) async {
    print("unit_id=====>$unit_id");
    print("exam_id=====>$exam_id");

    var requestBody = {"unit_id": unit_id, "exam_id": exam_id};
    isLoading(true);
    try {
      var res = await ApiCall().gameResult(requestBody);
      var body = json.decode(res.body);
      print("body game result=====>$body");

      if (res.statusCode == 200) {
        if (body['status'] == true || body['status'] == "true") {
          // Assign the data map to gameResultData using assignAll to preserve reactivity
          gameResultData.assignAll(body['data']);
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
}
