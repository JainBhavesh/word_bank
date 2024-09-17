import 'dart:convert';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

class ReviewTestController extends GetxController {
  var isLoading = false.obs;
  var examTypeList = <Map<String, dynamic>>[].obs;
  var examData = [].obs;
  var reviewData = [].obs;
  var aiData = Rx<Map<String, dynamic>>({});

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
        var errorResponse = json.decode(res.body) as Map<String, dynamic>;
        Get.snackbar(
            'Error', errorResponse['message'] ?? 'Unknown error occurred',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  void exam({required int unit_id, required int exam_id}) async {
    isLoading(true);
    try {
      var res = await ApiCall().getExam(unit_id, exam_id);

      if (res.statusCode == 200) {
        isLoading(false);
        var body = json.decode(res.body);
        print("question-->$body");
        if (body['status'] == true || body['status'] == "true") {
          examData.value = body['data']; // Store the exam data here
        } else {
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        isLoading(false);
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
      print('Network error: $e'); // Debugging
    } finally {
      isLoading(false);
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
  void aiDataGenerate({required String word}) async {
    print("word=====>$word");
    isLoading(true);
    try {
      var res = await ApiCall().aiDataHandler(word);
      var body = json.decode(res.body);
      print("body=====>$body");

      if (res.statusCode == 200) {
        if (body['status'] == true || body['status'] == "true") {
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
}
