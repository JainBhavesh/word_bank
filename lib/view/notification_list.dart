import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes_name.dart';
import '../view_model/controller/notification_controller.dart';

class NotificationListScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  // ignore: override_on_non_overriding_member
  void initState() {
    controller.getNotificationCount();
    controller.getTodayTask(); // Fetch notification count on screen load
  }

  void fetchData() {
    controller.getNotificationCount();
    controller.getTodayTask();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<NotificationController>(() => NotificationController());
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            fetchData();
          },
        ),
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
            var typeData = notification['unit'];
            // DateTime? targetDate =
            //     controller.parseDate(typeData['target_date']);

            // Ensure remaining_days is an integer or 0 if not an int
            int remainingDays = (typeData['remaining_day'] is int)
                ? typeData['remaining_day']
                : (typeData['remaining_day'] is String &&
                        typeData['remaining_day'] == "finish")
                    ? 0 // Handle case for "finish"
                    : 0;
            if (notification['exam_id'] == 1) {
              onTap = () {
                Get.toNamed(
                  RouteName.examBoardScreen,
                  arguments: {
                    'unitId': notification['unit_id'],
                    'examId': 1,
                    "notification_id": notification['notification_id'],
                    'mainUnitId': 0,
                    'daysLeft': remainingDays,
                  },
                );
                // Get.toNamed(
                //   RouteName.wordPuzzleScreen,
                //   arguments: {
                //     'unitId': notification['unit_id'],
                //     'examId': 1,
                //     "notification_id": notification['notification_id'],
                //     'mainUnitId': 0
                //   },
                // );
              };
            } else if (notification['exam_id'] == 2) {
              onTap = () {
                Get.toNamed(
                  RouteName.examBoardScreen,
                  arguments: {
                    'unitId': notification['unit_id'],
                    'examId': 2,
                    "notification_id": notification['notification_id'],
                    'mainUnitId': 0,
                    'daysLeft': remainingDays,
                  },
                );
                // Get.toNamed(
                //   RouteName.advanceWordPuzzleScreen,
                //   arguments: {
                //     'unitId': notification['unit_id'],
                //     'examId': 2,
                //     "notification_id": notification['notification_id'],
                //     'mainUnitId': 0
                //   },
                // );
              };
            } else if (notification['exam_id'] == 3) {
              onTap = () {
                Get.toNamed(
                  RouteName.examBoardScreen,
                  arguments: {
                    'unitId': notification['unit_id'],
                    'examId': 3,
                    "notification_id": notification['notification_id'],
                    'mainUnitId': 0,
                    'daysLeft': remainingDays,
                  },
                );
                // Get.toNamed(
                //   RouteName.matchingModeScreen,
                //   arguments: {
                //     'unitId': notification['unit_id'],
                //     'examId': 3,
                //     "notification_id": notification['notification_id'],
                //     'mainUnitId': 0
                //   },
                // );
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
