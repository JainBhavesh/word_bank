import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/controller/about_data_controller.dart';

class About extends StatelessWidget {
  final AboutDataController controller = Get.put(AboutDataController());
  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'about'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                print("about==>${controller.aboutData}");
                return Text(
                  controller
                      .aboutData.value, // Assuming aboutData is an RxString
                  style: TextStyle(
                    fontSize: 18,
                    height: 2, // Line height for readability
                  ),
                );
              }),
            ),
          ],
        ));
  }
}
