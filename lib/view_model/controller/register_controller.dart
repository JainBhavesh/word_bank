import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:word_bank/view_model/services/auth_service.dart';

import '../../view/insta_view_login.dart';

class RegisterController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var agreeToTerms = false.obs;
  var instagramToken = ''.obs;
  var instagramUserId = ''.obs;
  var instagramUsername = ''.obs;

  final AuthService _authService = AuthService();

  // Method for registration
  void register() async {
    if (email.value.isEmpty || password.value.isEmpty || !agreeToTerms.value) {
      Get.snackbar('Error', 'Please fill all fields and agree to the terms');
    } else {
      User? user = await _authService.registerWithEmailPassword(
          email.value, password.value);
      if (user != null) {
        Get.snackbar('Success', 'Registered successfully');
      } else {
        Get.snackbar('Error', 'Registration failed');
      }
    }
  }

  // Method for Google sign-in
  Future<void> signInWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Get.snackbar('Success', 'Signed in as ${user.displayName}');
    } else {
      Get.snackbar('Error', 'Google sign-in failed');
    }
  }

  // Method for Facebook sign-in
  Future<void> signInWithFacebook() async {
    User? user = await _authService.signInWithFacebook();
    if (user != null) {
      Get.snackbar('Success', 'Signed in as ${user.displayName}');
    } else {
      Get.snackbar('Error', 'Facebook sign-in failed');
    }
  }

  // Method for email and password sign-in
  Future<void> signIn() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
    } else {
      User? user = await _authService.signInWithEmailPassword(
          email.value, password.value);
      if (user != null) {
        Get.snackbar('Success', 'Signed in successfully');
      } else {
        Get.snackbar('Error', 'Sign-in failed');
      }
    }
  }

  // Method for Instagram sign-in
  Future<void> signInWithInstagram() async {
    try {
      final result = await Get.to(() => const InstaLoginScreen(
            instaAppId: '215643524910532',
            instaAppSecret: 'b19d87bf98b632e0319f2ebab495b345',
            redirectUrl:
                'https://my.m.redirect.net/?code=abcdefghijklmnopqrstuvwxyz#_/',
          ));

      if (result != null) {
        // Handle the result from the screen
        instagramToken.value = result['token'];
        instagramUserId.value = result['userId'];
        instagramUsername.value = result['username'];
        Get.snackbar('Success', 'Signed in with Instagram');
      } else {
        Get.snackbar('Error', 'Instagram sign-in failed');
      }
    } catch (error) {
      print("Error during Instagram login: $error");
      Get.snackbar('Error', 'Instagram sign-in failed');
    }
  }

  // Method for sign-out
  Future<void> signOut() async {
    await _authService.signOut();
    Get.snackbar('Success', 'Signed out successfully');
  }
}
