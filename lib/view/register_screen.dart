import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/controller/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        title: Text('register'.tr),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.create),
                SizedBox(width: 5),
                Text('38812'),
              ],
            ),
          ),
        ],
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
                        'name'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => controller.name.value = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'enter_name'.tr,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'email'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => controller.email.value = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'enter_email'.tr,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'password'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => controller.password.value = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'enter_password'.tr,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: controller.agreeToTerms.value,
                              onChanged: (value) {
                                controller.agreeToTerms.value = value!;
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('agree_to_terms'.tr),
                              Text('description'.tr,
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'register'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'system_message'.tr,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              SocialMediaButton(
                text: '用 Google 帳號註冊',
                color: Colors.white,
                textColor: Colors.black,
                icon: Icons.g_mobiledata,
                onPressed: () {
                  // Handle Google registration
                  // controller.signInWithGoogle();
                  // Get.snackbar('Google', 'Google registration pressed');
                },
              ),
              const SizedBox(height: 16),
              SocialMediaButton(
                text: '用 facebook 帳號註冊',
                color: Colors.blue,
                textColor: Colors.white,
                icon: Icons.facebook,
                onPressed: () {
                  // Handle Facebook registration
                  // controller.signInWithFacebook();
                  // Get.snackbar('Facebook', 'Facebook registration pressed');
                },
              ),
              const SizedBox(height: 16),
              SocialMediaButton(
                text: '用 instagram 帳號註冊',
                color: Colors.pink,
                textColor: Colors.white,
                icon: Icons.camera_alt,
                onPressed: () {
                  // controller.signInWithInstagram();
                  // Get.snackbar('Instagram', 'Instagram registration pressed');
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
