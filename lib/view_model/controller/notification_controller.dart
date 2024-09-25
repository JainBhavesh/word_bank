import 'dart:convert';
import 'package:get/get.dart';
import 'package:word_bank/apis/api_call.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var dateList = <dynamic>[].obs;
  RxInt notificationCount = 0.obs; // Reactive count using GetX
  var notificationList = [].obs; // List to hold the notifications

  @override
  void onInit() {
    super.onInit();
    getNotificationCount();
    getTodayTask();
    getNotification();
  }

  void getNotificationCount() async {
    isLoading(true);
    try {
      var res = await ApiCall().notificationCount();

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          notificationCount.value = body["data"];
          print('get notification-->$body');
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

  void getNotification() async {
    isLoading(true);
    try {
      var res = await ApiCall().getNotification();

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print("notifiction data==>$body");
        if (body['status'] == true || body['status'] == "true") {
          notificationList.assignAll(body['data']);
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

  void getTodayTask() async {
    isLoading(true);
    try {
      var res = await ApiCall().getTodayTask();

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          dateList.value = body['data'];
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
      return null;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Call the API every time the screen is rendered
    getNotification();
    getNotificationCount();
  }
}
