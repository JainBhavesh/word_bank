import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/controller/register_controller.dart';
import 'register_screen.dart'; // Import the RegisterScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('login'.tr), // Translated 'Login'
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         Icon(Icons.create),
        //         SizedBox(width: 5),
        //         Text('38812'),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'email'.tr, // Translated 'Email'
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => controller.email.value = value,
                        decoration: InputDecoration(
                          hintText: 'email'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'password'.tr, // Translated 'Password'
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => controller.password.value = value,
                        decoration: InputDecoration(
                          hintText: 'password'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      // Row(
                      //   children: [
                      //     Obx(
                      //       () => Checkbox(
                      //         value: controller.agreeToTerms.value,
                      //         onChanged: (value) {
                      //           controller.agreeToTerms.value = value!;
                      //         },
                      //       ),
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text('agree_to_terms'.tr),
                      //         Text('description'.tr,
                      //             style: const TextStyle(fontSize: 12)),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'login_button'.tr, // Translated 'Login'
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            text: "dont_have_account".tr + " ",
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'register'.tr, // Translated 'Register'
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const RegisterScreen());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SocialMediaButton(
                text: 'google_sign_up'.tr,
                color: Colors.white,
                textColor: Colors.black,
                icon: Icons.g_mobiledata,
                onPressed: () {
                  controller.signInWithGoogle();
                },
              ),
              const SizedBox(height: 16),
              SocialMediaButton(
                text: 'facebook_sign_up'.tr,
                color: Colors.blue,
                textColor: Colors.white,
                icon: Icons.facebook,
                onPressed: () {
                  controller.signInWithFacebook();
                },
              ),
              const SizedBox(height: 16),
              SocialMediaButton(
                text: 'instagram_sign_up'.tr,
                color: Colors.pink,
                textColor: Colors.white,
                icon: Icons.camera_alt,
                onPressed: () {
                  // controller.signInWithInstagram();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialMediaButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: Icon(icon, color: textColor),
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
