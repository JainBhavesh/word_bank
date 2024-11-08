import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_bank/view/login_screen.dart';
import '../../apis/api_call.dart';
import '../../utils/preference.dart';
import '../../view/home_screen.dart';
import '../../view/insta_view_login.dart';
// import '../services/auth_service.dart';
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

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void printWrapped(dynamic text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new user object
      if (googleUser != null && googleAuth != null) {
        // Get user details
        String displayName = googleUser.displayName ?? "No Name";
        String email = googleUser.email;
        String photoUrl = googleUser.photoUrl ?? "No Photo URL";
        String id = googleUser.id;

        // Create a user object
        Map<String, dynamic> user = {
          'id': id,
          'displayName': displayName,
          'email': email,
          'photoUrl': photoUrl,
          'accessToken': googleAuth.accessToken,
          'idToken': googleAuth.idToken,
        };
        String userDataString = jsonEncode(user);
        print("user info google auth--->$userDataString");

        socialLogin("google", userDataString);
      }
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      print("result signInWithFacebook ----> $result");

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        if (accessToken != null) {
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          // Extract data from UserCredential and AccessToken to match your map structure
          Map<String, dynamic> user = {
            'id': userCredential.user?.uid ?? '',
            'displayName': userCredential.user?.displayName ?? '',
            'email': userCredential.user?.email ?? '',
            'photoUrl': userCredential.user?.photoURL ?? '',
            'accessToken': accessToken.tokenString, // Use tokenString here
            'idToken': '', // Facebook typically doesn't provide an idToken
          };

          // Convert user data to JSON string
          String userDataString = jsonEncode(user);

          // Pass user data to socialLogin
          socialLogin("facebook", userDataString);

          print("User info for Facebook login ---> $userDataString");
        }
      } else {
        print("Facebook sign-in failed ---> ${result.status}");
      }
    } catch (e) {
      print("Error signing in with Facebook: $e");
    }
  }

  // // Method for Facebook sign-in
  // Future<void> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     print("result signInWithFacebook---->$result");
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken? accessToken = result.accessToken;
  //       if (accessToken != null) {
  //         final OAuthCredential facebookAuthCredential =
  //             FacebookAuthProvider.credential(accessToken.tokenString);
  //         UserCredential userCredential =
  //             await _auth.signInWithCredential(facebookAuthCredential);
  //         print("userCredential===>$userCredential");
  //         String userDataString = jsonEncode(userCredential);
  //         socialLogin("facebook", userDataString);
  //       }
  //     } else {
  //       print("Facebook sign-in failed------>: ${result.status}");
  //     }
  //   } catch (e) {
  //     print("Error signing in with Facebook: $e");
  //     return null;
  //   }
  // }

  void socialLogin(type, obj) async {
    if (obj == null) {
      Get.snackbar('Validation Error', "Need to send all data",
          snackPosition: SnackPosition.TOP);
      return;
    }

    showLoader();
    var requestBody = {
      "type": type,
      "data": obj,
    };
    print("social body====>${requestBody}");

    try {
      var res = await ApiCall().login(requestBody);
      hideLoader();
      var body = json.decode(res.body);
      print("scoil response---->$body");
      if (res.statusCode == 200) {
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

      final result = await Get.to(() => const InstaLoginScreen(
          instaAppId: '1707420580109291',
          instaAppSecret: '1340639857aa4ef6e20a7b417bb92e14',
          redirectUrl:
              // 'https://my.m.redirect.net/?code=abcdefghijklmnopqrstuvwxyz#_/',
              'https://yourdomain.com/oauth_callback'));

      // Hide the loader
      print("signInWithInstagram user info-->${result}");

      if (result != null) {
        // Assuming 'result' contains 'token', 'userId', 'username', 'profilePicture'
        Map<String, dynamic> user = {
          'id': result['userId'],
          'displayName': result['username'],
          'email': result['email'] ?? '',
          'photoUrl': result['profilePicture'] ?? '',
          'accessToken': result['token'],
          'idToken': '', // Instagram typically doesn't return an idToken
        };

        String userDataString = jsonEncode(user);
        socialLogin("instagram", userDataString);

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
