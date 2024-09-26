// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../components/CustomBottomNavigationBar.dart';
// import '../components/SettingsTab.dart';
// import '../components/TaskCircle.dart';
// import '../routes/routes_name.dart';
// import '../view_model/controller/notification_controller.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final NotificationController notificationController =
//       Get.put(NotificationController());
//   int _selectedIndex = 0;
//   final List<int> _tasks = List.generate(6, (index) => 23);
//   // final List<int> _tasks = [22, 22, 22, 22, 22, 22];

//   void _onBottomNavTapped(int index) {
//     if (index == 0) {
//       _showSettingsModal();
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _finishTask(int index) {
//     setState(() {
//       _tasks[index] = 0;
//     });
//     Get.toNamed(RouteName.pushTestScreen);
//   }

//   void _showSettingsModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           builder: (context, scrollController) {
//             return SettingsScreen(
//               scrollController: scrollController,
//               onClose: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   _selectedIndex = 0;
//                 });
//               },
//             );
//           },
//         );
//       },
//     ).whenComplete(() {
//       setState(() {
//         _selectedIndex = 0;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("_tasks-->$_tasks");

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('拼了', style: TextStyle(color: Colors.orange)),
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person, color: Colors.purple),
//             onPressed: () {
//               // Get.toNamed(RouteName.registerScreen);
//             },
//           ),
//         ],
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             // Image.asset('assets/ninja.png', height: 150),
//             const Center(
//               child: FlutterLogo(
//                 size: 220,
//                 textColor: Colors.red,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to Personal Wordbank and pass userId parameter
//                     Get.toNamed(RouteName.personalWordBankScreen,
//                         parameters: {"type": "personal", "userId": "1"});
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'Personal wordbank',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to Built-in Wordbank without userId
//                     Get.toNamed(RouteName.builtinWordBankScreen,
//                         parameters: {"type": "builtin"});
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'Built-in wordbank',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding:
//                     EdgeInsets.only(left: 40.0), // Adjust the value as needed
//                 child: Text(
//                   "Today's task",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // Number of columns
//                   mainAxisSpacing: 20,
//                   crossAxisSpacing: 20,
//                 ),
//                 itemCount: _tasks.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () => _finishTask(index),
//                     child: TaskCircle(
//                       daysLeft: _tasks[index],
//                       isFinish: _tasks[index] == 0,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onBottomNavTapped,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/CustomBottomNavigationBar.dart';
import '../components/SettingsTab.dart';
import '../routes/routes_name.dart';
import '../view_model/controller/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  int _selectedIndex = 0;
  int selectedUnitIndex = 0;
  void _onBottomNavTapped(int index) {
    if (index == 0) {
      _showSettingsModal();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    notificationController
        .getNotificationCount(); // Fetch notification count on screen load
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SettingsScreen(
              scrollController: scrollController,
              onClose: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 0;
                });
              },
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        _selectedIndex = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拼了', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.purple),
            onPressed: () {
              // Navigate to Profile Screen
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_on_sharp,
                    color: Colors.purple),
                onPressed: () {
                  Get.toNamed(RouteName.noticationScreen);
                  // Navigate to Notification Screen
                },
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Obx(() {
                  return notificationController.notificationCount.value > 0
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${notificationController.notificationCount.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(); // Hide if count is 0
                }),
              ),
            ],
          ),
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
              const Center(
                child: FlutterLogo(
                  size: 220,
                  textColor: Colors.red,
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
                    child: const Text(
                      'Personal wordbank',
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
                    child: const Text(
                      'Built-in wordbank',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              notificationController.dateList.isNotEmpty
                  ? const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40.0, top: 20),
                        child: Text(
                          "Today's task",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "No tasks available",
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: notificationController.dateList.length,
                  itemBuilder: (context, index) {
                    var typeData = notificationController.dateList[index];
                    DateTime? targetDate = notificationController
                        .parseDate(typeData['target_date']);
                    int remainingDays = typeData['remaining_day'] ?? 0;

                    if (targetDate == null) {
                      return _buildUnplannedButton(typeData['id']);
                    } else if (targetDate.isBefore(DateTime.now())) {
                      return _buildFinishButton();
                    } else {
                      return _buildDaysLeftButton(
                          typeData['id'], remainingDays);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildFinishButton() {
    return GestureDetector(
      onTap: () {
        // Handle finish button tap
        print('Finish button pressed');
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow,
          border: Border.all(color: Colors.red, width: 4),
        ),
        child: const Center(
          child: Text(
            'Finish',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysLeftButton(int index, int daysLeft) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnitIndex = index;
        });
        Get.toNamed(RouteName.reviewOrTestScreen,
            arguments: {'unitId': index, 'daysLeft': daysLeft});
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: selectedUnitIndex == index ? Colors.blue : Colors.red,
            width: 4,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$daysLeft',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const Text(
                'Days left',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnplannedButton(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.targetDateScreen, arguments: {'unitId': index});
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          border: Border.all(color: Colors.grey.shade400, width: 4),
        ),
        child: const Center(
          child: Text(
            'unplanned',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
