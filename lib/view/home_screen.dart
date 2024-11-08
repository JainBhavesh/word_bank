import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/CustomBottomNavigationBar.dart';
import '../routes/routes_name.dart';
import '../view_model/controller/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const double buttonSize = 90;

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final NotificationController notificationController =
      Get.put(NotificationController());
  int _selectedIndex = 0;
  int selectedUnitIndex = 0;
  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Get.toNamed(RouteName.settings);
    } else if (index == 1) {
      Get.toNamed(RouteName.member);
    } else if (index == 2) {
      Get.toNamed(RouteName.achievement);
    } else if (index == 3) {
      Get.toNamed(RouteName.about);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addObserver(this); // Add observer
    fetchData();
    // Fetch notification count on screen load
  }

  void fetchData() {
    // notificationController.getNotificationCount();
    notificationController.getTodayTask();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data again whenever dependencies change (e.g., coming back to this screen)
    // notificationController.getNotificationCount();
    notificationController.getTodayTask();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<NotificationController>(() => NotificationController());

    return Scaffold(
      appBar: AppBar(
        // title: const Text('拼了', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        actions: [
          Obx(
            () => Row(
              children: [
                Icon(
                  Icons.create,
                  size: 20,
                ),
                SizedBox(width: 5),
                Text('${notificationController.totalCount.value}'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.purple),
            onPressed: () {
              // Navigate to Profile Screen
            },
          ),
          // Stack(
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.notifications_on_sharp,
          //           color: Colors.purple),
          //       onPressed: () {
          //         Get.toNamed(RouteName.noticationScreen);
          //         // Navigate to Notification Screen
          //       },
          //     ),
          //     Positioned(
          //       right: 11,
          //       top: 11,
          //       child: Obx(() {
          //         return notificationController.notificationCount.value > 0
          //             ? Container(
          //                 padding: const EdgeInsets.all(2),
          //                 decoration: BoxDecoration(
          //                   color: Colors.red,
          //                   borderRadius: BorderRadius.circular(20),
          //                 ),
          //                 constraints: const BoxConstraints(
          //                   minWidth: 14,
          //                   minHeight: 14,
          //                 ),
          //                 child: Text(
          //                   '${notificationController.notificationCount.value}',
          //                   style: const TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 10,
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               )
          //             : const SizedBox(); // Hide if count is 0
          //       }),
          //     ),
          //   ],
          // ),
        ],
        elevation: 0,
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/boy.png', // Ensure this path is correct
                  fit: BoxFit.cover,
                  width: 155,
                  height: 190,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Personal Wordbank and pass userId parameter
                      Get.toNamed(RouteName.personalWordBankScreen,
                          parameters: {"type": "personal", "userId": "1"});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'personal_wordbank'.tr,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Built-in Wordbank without userId
                      Get.toNamed(RouteName.builtinWordBankScreen,
                          parameters: {"type": "builtin"});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'built_in_wordbank'.tr,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              notificationController.dateList.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40.0, top: 20),
                        child: Text(
                          "todays_task".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "no_tasks_available".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: notificationController.dateList.length,
                      itemBuilder: (context, index) {
                        var todayTaskData =
                            notificationController.dateList[index];
                        var typeData = todayTaskData['unit'];
                        DateTime? targetDate = notificationController
                            .parseDate(typeData['target_date']);

                        // Ensure remaining_days is an integer or 0 if not an int
                        int remainingDays = (typeData['remaining_day'] is int)
                            ? typeData['remaining_day']
                            : (typeData['remaining_day'] is String &&
                                    typeData['remaining_day'] == "finish")
                                ? 0 // Handle case for "finish"
                                : 0; // Default to 0 for other cases
                        if (targetDate == null) {
                          return _buildUnplannedButton(typeData['id']);
                        } else if (typeData['remaining_day'] == "finish") {
                          return _buildFinishButton(todayTaskData);
                        } else {
                          return _buildDaysLeftButton(todayTaskData);
                        }
                      })),
              CustomBottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onBottomNavTapped,
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFinishButton(todayTaskData) {
    var typeData = todayTaskData['unit'];
    int remainingDays = (typeData['remaining_day'] is int)
        ? typeData['remaining_day']
        : (typeData['remaining_day'] is String &&
                typeData['remaining_day'] == "finish")
            ? 0 // Handle case for "finish"
            : 0;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnitIndex = typeData['id'];
        });
        // Get.toNamed(RouteName.reviewOrTestScreen, arguments: {
        //   'unitId': index,
        //   'daysLeft': daysLeft,
        // });
        print('todayTaskData data===>${todayTaskData}');
        Get.toNamed(
          RouteName.examBoardScreen,
          arguments: {
            'unitId': typeData['id'],
            'examId': todayTaskData['exam_id'],
            "notification_id": todayTaskData['notification_id'],
            'mainUnitId': 0,
            'daysLeft': remainingDays,
          },
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circle with dynamic background color based on daysLeft
          Container(
            width: buttonSize, // Same size as progress indicator
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: remainingDays == 0
                  ? const Color(
                      0xFFF8EF1E) // Yellow background when daysLeft == 0
                  : const Color(0xFFF2F2F2), // Default background color
            ),
          ),
          SizedBox(
            width: buttonSize, // Adjusted size for progress indicator
            height: buttonSize,
            child: CircularProgressIndicator(
              value: 1, // Dynamic value based on the exam_count
              strokeWidth: 10,
              color: Colors.red, // The color of the progress
              backgroundColor: Colors.red,
            ),
          ),
          Center(
            child: Text(
              remainingDays == 0
                  ? 'finish'.tr
                  : '$remainingDays\n${'days_left'.tr}', // Using .tr for translations
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysLeftButton(todayTaskData) {
    print("todayTaskData==>$todayTaskData");
    var typeData = todayTaskData['unit'];
    int remainingDays = (typeData['remaining_day'] is int)
        ? typeData['remaining_day']
        : (typeData['remaining_day'] is String &&
                typeData['remaining_day'] == "finish")
            ? 0 // Handle case for "finish"
            : 0;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnitIndex = typeData['id'];
        });
        // Get.toNamed(RouteName.reviewOrTestScreen,
        //     arguments: {'unitId': index, 'daysLeft': daysLeft});
        Get.toNamed(
          RouteName.examBoardScreen,
          arguments: {
            'unitId': typeData['id'],
            'examId': todayTaskData['exam_id'],
            "notification_id": todayTaskData['notification_id'],
            'mainUnitId': 0,
            'daysLeft': remainingDays,
          },
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circle with dynamic background color based on daysLeft
          Container(
            width: buttonSize, // Same size as progress indicator
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFBC120F), // Red background for other cases
            ),
          ),
          SizedBox(
            width: buttonSize, // Adjusted size for progress indicator
            height: buttonSize,
            child: CircularProgressIndicator(
              value: (typeData['exam_count']?.toDouble() ?? 0) / 8,
              strokeWidth: 10,
              color: Colors.red, // The color of the progress
              backgroundColor:
                  Colors.white, // Background of the circle progress
            ),
          ),
          Center(
            child: Text(
              remainingDays == 0
                  ? 'finish'.tr
                  : '$remainingDays\n${'days_left'.tr}', // Using .tr for translations
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white), // White text on red background
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnplannedButton(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.targetDateScreen,
            arguments: {'unitId': index, "wordBankId": Get.arguments['id']});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: buttonSize, // Same size as progress indicator
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFBDBDBD), // Red background for other cases
            ),
          ),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: CircularProgressIndicator(
              value: 0, // Placeholder value (0.5), adjust based on your logic
              strokeWidth: 10,
              color: Colors.white,
              backgroundColor: Colors.white,
            ),
          ),
          Center(
            child: Text(
              'unplanned'.tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
