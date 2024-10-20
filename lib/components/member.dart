import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';

import '../utils/preference.dart';
import '../view_model/controller/bottom_controller.dart';

class Member extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulated logged-in username
    final BottomController controller = Get.put(BottomController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title "Member"
            Text(
              'member'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            // Logged-in information
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blueAccent),
                title: Text(
                  'logged_in_user'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: Obx(() {
                  return Text(
                    controller.userData["name"] ?? "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  );
                }),
              ),
            ),
            SizedBox(height: 30),

            // List of Actions
            Expanded(
              child: ListView(
                children: [
                  // Log out option
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.redAccent),
                      title: Text(
                        'log_out'.tr,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Show confirmation dialog before logging out
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('log_out'.tr),
                              content: Text('log_out_msg'.tr),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('cancel'.tr),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('log_out'.tr),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    controller.logout().then((_) {
                                      Future.delayed(const Duration(seconds: 2),
                                          () async {
                                        await Preference.saveString(
                                            'token', '');
                                        Get.toNamed(RouteName.loginScreen);
                                      });
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Change password option
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.lock, color: Colors.blueAccent),
                      title: Text(
                        'change_password'.tr,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Get.toNamed(RouteName.changePassword);
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Edit nickname option
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.green),
                      title: Text(
                        'Edit_nickname'.tr,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Get.toNamed(RouteName.editUser);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
