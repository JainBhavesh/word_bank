// import 'dart:convert';
// import 'package:get/get.dart';
// import '../../apis/api_call.dart';

// class WordsController extends GetxController {
//   var wordList = <dynamic>[].obs;
//   var isLoading = false.obs;
//   final int wordbankId;

//   WordsController({required this.wordbankId});

//   @override
//   void onInit() {
//     super.onInit();
//     getWordsList();
//   }

//   void getWordsList() async {
//     isLoading(true);
//     try {
//       // Use wordbankId in the API call to fetch words
//       var res = await ApiCall().getWords(wordbankId);
//       isLoading(false);
//       print('wordbankId---->$wordbankId');
//       if (res.statusCode == 200) {
//         var body = json.decode(res.body);

//         if (body['status'] == true || body['status'] == "true") {
//           wordList.value = body['data'].reversed.toList();
//         } else {
//           Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
//               snackPosition: SnackPosition.TOP);
//         }
//       } else {
//         var errorResponse = json.decode(res.body);
//         String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
//         Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
//       }
//     } catch (e) {
//       isLoading(false);
//       Get.snackbar('Network Error',
//           'Unable to reach the server. Please check your internet connection.',
//           snackPosition: SnackPosition.TOP);
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import '../../apis/api_call.dart';

class WordsController extends GetxController {
  var wordList = <dynamic>[].obs;
  var isLoading = false.obs;
  final int wordbankId;

  WordsController({required this.wordbankId});

  @override
  void onInit() {
    super.onInit();
    getWordsList();
  }

  void getWordsList() async {
    isLoading(true);
    try {
      // Use wordbankId in the API call to fetch words
      print('Fetching words for wordbankId: $wordbankId'); // Debugging
      var res = await ApiCall().getWords(wordbankId);

      print('API Response: ${res.body}'); // Debugging
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body['status'] == true || body['status'] == "true") {
          wordList.value = body['data'].reversed.toList();
          print('Word list updated successfully'); // Debugging
        } else {
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
          print('Error in response: ${body['message']}'); // Debugging
        }
      } else {
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
        print('Error message: $errorMsg'); // Debugging
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
