import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:word_bank/view/login_screen.dart';
import '../../apis/api_call.dart';
import '../../utils/preference.dart';
import '../../view/home_screen.dart';
import '../../view/insta_view_login.dart';
import '../services/auth_service.dart';
// import '../../view/insta_view_login.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var errorMessage = ''.obs;
  var instagramToken = ''.obs;
  var instagramUserId = ''.obs;
  var instagramUsername = ''.obs;
  var agreeToTerms = false.obs;

  final AuthService _authService = AuthService();

  // Method for validating email
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address';
    }
    String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Method for validating password
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Method for validating name
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Method to show loader
  void showLoader() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  // Method to hide loader
  void hideLoader() {
    if (Get.isDialogOpen!) {
      Get.back(); // Close the loader
    }
  }

  void register() async {
    String? nameError = validateName(name.value);
    String? emailError = validateEmail(email.value);
    String? passwordError = validatePassword(password.value);

    if (nameError != null) {
      Get.snackbar('Validation Error', nameError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (emailError != null) {
      Get.snackbar('Validation Error', emailError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordError != null) {
      Get.snackbar('Validation Error', passwordError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    // Show loader before making the API call
    showLoader();

    var requestBody = {
      "name": name.value,
      "email": email.value,
      "password": password.value,
    };

    try {
      // Make the registration API call
      var res = await ApiCall().register(requestBody);

      // Hide the loader after the API call
      hideLoader();

      print("register res body --> ${res.body}");

      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        if (body['status'] == true || body['status'] == "true") {
          await Preference.saveString('token', body['token']);
          await Preference.saveInt('userId', body['user']['id']);
          Get.offAll(() => const LoginScreen());
          Get.snackbar('Success', 'Registration successful',
              snackPosition: SnackPosition.TOP);
        } else {
          errorMessage.value = body['message'] ?? 'Unknown error occurred';
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
      // ignore: non_constant_identifier_names
    } catch (SocketException) {
      // Handle network error
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }

  void login() async {
    String? emailError = validateEmail(email.value);
    String? passwordError = validatePassword(password.value);

    if (emailError != null) {
      Get.snackbar('Validation Error', emailError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordError != null) {
      Get.snackbar('Validation Error', passwordError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    // Show loader before making the API call
    showLoader();
    var requestBody = {
      "email": email.value,
      "password": password.value,
    };
    print("login call====>${requestBody}");

    try {
      // Make the login API call
      var res = await ApiCall().login(requestBody);

      // Hide the loader after the API call
      hideLoader();

      var body = json.decode(res.body);
      print("login response---->$body");
      if (res.statusCode == 200) {
        // Handle both boolean true and string "true"
        if (body['status'] == true || body['status'] == "true") {
          await Preference.saveString('token', body['token']);
          await Preference.saveInt('userId', body['user']['id']);
          Get.snackbar('Success', 'Login successful',
              snackPosition: SnackPosition.TOP);
          Get.offAll(() => const HomeScreen());
        } else {
          errorMessage.value = body['message'] ?? 'Unknown error occurred';
          Get.snackbar('Error', body['message'] ?? 'Unknown error occurred',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        var errorResponse = json.decode(res.body);
        String errorMsg = errorResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
      // ignore: non_constant_identifier_names
    } catch (SocketException) {
      // Handle network error
      hideLoader();
      Get.snackbar('Network Error',
          'Unable to reach the server. Please check your internet connection.',
          snackPosition: SnackPosition.TOP);
    }
  }

  // Method for Google sign-in
  Future<void> signInWithGoogle() async {
    // Show the loader
    showLoader();

    User? user = await _authService.signInWithGoogle();

    // Hide the loader
    hideLoader();
    print("sign in user inf-->${user}");
    if (user != null) {
      Get.snackbar('Success', 'Signed in as ${user.displayName}',
          snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Error', 'Google sign-in failed',
          snackPosition: SnackPosition.TOP);
    }
  }

  // Method for Facebook sign-in
  Future<void> signInWithFacebook() async {
    // Show the loader
    showLoader();

    User? user = await _authService.signInWithFacebook();
    print("signInWithFacebook user inf-->${user}");
    // Hide the loader
    hideLoader();

    if (user != null) {
      Get.snackbar('Success', 'Signed in as ${user.displayName}',
          snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Error', 'Facebook sign-in failed',
          snackPosition: SnackPosition.TOP);
    }
  }

  // Method for email and password sign-in
  // Future<void> signIn() async {
  //   if (email.value.isEmpty || password.value.isEmpty) {
  //     Get.snackbar('Error', 'Please fill in all fields',
  //         snackPosition: SnackPosition.TOP);
  //   } else {
  //     // Show the loader
  //     showLoader();

  //     User? user = await _authService.signInWithEmailPassword(
  //         email.value, password.value);

  //     // Hide the loader
  //     hideLoader();

  //     if (user != null) {
  //       Get.snackbar('Success', 'Signed in successfully',
  //           snackPosition: SnackPosition.TOP);
  //     } else {
  //       Get.snackbar('Error', 'Sign-in failed',
  //           snackPosition: SnackPosition.TOP);
  //     }
  //   }
  // }

  // Method for Instagram sign-in
  Future<void> signInWithInstagram() async {
    try {
      // Show the loader
      showLoader();

      final result = await Get.to(() => const InstaLoginScreen(
            instaAppId: '215643524910532',
            instaAppSecret: 'b19d87bf98b632e0319f2ebab495b345',
            redirectUrl:
                'https://my.m.redirect.net/?code=abcdefghijklmnopqrstuvwxyz#_/',
          ));

      // Hide the loader
      hideLoader();
      print("signInWithInstagram user inf-->${result}");

      if (result != null) {
        // Handle the result from the screen
        instagramToken.value = result['token'];
        instagramUserId.value = result['userId'];
        instagramUsername.value = result['username'];
        Get.snackbar('Success', 'Signed in with Instagram',
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Error', 'Instagram sign-in failed',
            snackPosition: SnackPosition.TOP);
      }
    } catch (error) {
      print("Error during Instagram login: $error");
      Get.snackbar('Error', 'Instagram sign-in failed',
          snackPosition: SnackPosition.TOP);
    }
  }

  // Method for sign-out
  Future<void> signOut() async {
    // await _authService.signOut();
    // Get.snackbar('Success', 'Signed out successfully',
    //     snackPosition: SnackPosition.TOP);
  }
}
