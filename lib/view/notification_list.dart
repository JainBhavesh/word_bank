import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes_name.dart';
import '../view_model/controller/notification_controller.dart';

class NotificationListScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.notificationList.isEmpty) {
          return Center(child: Text('No notifications available.'));
        }

        return ListView.builder(
          itemCount: controller.notificationList.length,
          itemBuilder: (context, index) {
            final notification = controller.notificationList[index];
            // Determine onTap behavior based on exam_name
            VoidCallback onTap;

            if (notification['exam_name'] == 'Easy Mode') {
              onTap = () {
                Get.toNamed(
                  RouteName.wordPuzzleScreen,
                  arguments: {'unitId': notification['user_id'], 'examId': 1},
                );
              };
            } else if (notification['exam_name'] == 'Advance Mode') {
              onTap = () {
                Get.toNamed(
                  RouteName.advanceWordPuzzleScreen,
                  arguments: {'unitId': notification['user_id'], 'examId': 2},
                );
              };
            } else if (notification['exam_name'] == 'Matching Mode') {
              onTap = () {
                Get.toNamed(
                  RouteName.matchingModeScreen,
                  arguments: {'unitId': notification['user_id'], 'examId': 3},
                );
              };
            } else {
              // Default action if none of the conditions match
              onTap = () {
                Get.snackbar(
                    'Unknown Mode', 'No action available for this mode.');
              };
            }

            return NotificationCard(
              examName: notification['exam_name'] ?? 'No Exam Name',
              avatarPath:
                  'assets/images/splash_image.png', // Local asset image path
              onTap: onTap, // Pass the onTap function to the card
            );
          },
        );
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String examName;
  final String avatarPath;
  final VoidCallback onTap; // New onTap callback

  const NotificationCard({
    Key? key,
    required this.examName,
    required this.avatarPath, // Local asset image path
    required this.onTap, // Accept onTap function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(avatarPath), // Using local asset image
        ),
        title: Text(examName),
        onTap: onTap, // Handle tap event
      ),
    );
  }
}
