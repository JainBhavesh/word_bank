import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/controller/bottom_controller.dart';

class Achievement extends StatelessWidget {
  final BottomController controller = Get.put(BottomController());

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'achievement'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              return Text(
                'You have finished ${controller.getAchievementData["units_count"] ?? 0} units',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            }),
            SizedBox(height: 15),
            Obx(() {
              return Text(
                'Total points: ${controller.getAchievementData["total_count"] ?? 0}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            }),
            SizedBox(height: 15),
            Obx(() {
              return Text(
                'Points this week: ${controller.getAchievementData["week_count"] ?? 0}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            }),
          ],
        ),
      ),
    );
  }
}
