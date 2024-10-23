import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/word_list_popup.dart';
import 'package:word_bank/routes/routes_name.dart';
import '../components/button_widget.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/review_test_controller.dart';

class ExamBoardScreen extends StatefulWidget {
  const ExamBoardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExamBoardScreenState createState() => _ExamBoardScreenState();
}

const double buttonSize = 120;

class _ExamBoardScreenState extends State<ExamBoardScreen> {
  final List<Color> colors = [
    Color(0xFFf2c94c),
    Color(0xFFf2994a),
    Color(0xFFeb5757),
    Color(0xFF56ccf2)
  ];
  final NotificationController notificationController =
      Get.put(NotificationController());
  late final ReviewTestController _controller;
  late int unitId;
  late int daysLeft;
  late int mainUnitId;
  late int examId;
  late int notification_id;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ReviewTestController());

    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    daysLeft = arguments['daysLeft'] ?? 0;
    mainUnitId = arguments['mainUnitId'] ?? 0;
    examId = arguments['examId'] ?? 0;
    notification_id = arguments['notification_id'] ?? 0;

    print("exami -->$examId");

    _controller.getExamTypeList(unit_id: unitId);
    // _controller.getUnitWordsList(unit_id: unitId);
  }

  void _showWordListPopup() {
    print("Showing word list popup for unitId: $unitId");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordListPopup(
          unitId: unitId, // Pass only unitId to the popup
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('review_test'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Obx(
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
          ),
          SizedBox(width: 15), // Add margin left
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'view_words'.tr,
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    _showWordListPopup();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              return CircularCountdownWidget(
                  daysLeft: daysLeft, total: _controller.total.value);
            }),
            const SizedBox(height: 20),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Iterate over examTypeList and assign colors by index
                  ..._controller.examTypeList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> examType = entry.value;

                    // Define onTap function based on the mode
                    VoidCallback? onTap;
                    if (examType['id'] == 1) {
                      onTap = () {
                        Get.toNamed(RouteName.wordPuzzleScreen, arguments: {
                          'unitId': unitId,
                          'examId': 1,
                          'mainUnitId': mainUnitId
                        });
                      };
                    } else if (examType['id'] == 2) {
                      onTap = () {
                        Get.toNamed(RouteName.advanceWordPuzzleScreen,
                            arguments: {
                              'unitId': unitId,
                              'examId': 2,
                              'mainUnitId': mainUnitId
                            });
                      };
                    } else if (examType['id'] == 3) {
                      onTap = () {
                        Get.toNamed(RouteName.matchingModeScreen, arguments: {
                          'unitId': unitId,
                          'examId': 3,
                          'mainUnitId': mainUnitId
                        });
                      };
                    }

                    return ModeWidget(
                      label: examType['name'] ?? 'Unknown',
                      count: examType['count'] ?? 0,
                      color: colors[
                          index % colors.length], // Assign color based on index
                      // onTap: onTap,
                    );
                  }).toList(),
                ],
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Conditionally render the buttons based on examId
                    if (examId == 1) ...[
                      ButtonWidget(
                        label: 'easy_mode'.tr,
                        onPressed: () {
                          Get.toNamed(RouteName.wordPuzzleScreen, arguments: {
                            'unitId': unitId,
                            'examId': 1,
                            'mainUnitId': mainUnitId,
                            'notification_id': notification_id
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ] else if (examId == 2) ...[
                      ButtonWidget(
                        label: 'advanced_mode'.tr,
                        onPressed: () {
                          Get.toNamed(RouteName.advanceWordPuzzleScreen,
                              arguments: {
                                'unitId': unitId,
                                'examId': 2,
                                'mainUnitId': mainUnitId,
                                'notification_id': notification_id
                              });
                        },
                      ),
                      const SizedBox(height: 10),
                    ] else if (examId == 3) ...[
                      ButtonWidget(
                        label: 'matching_mode'.tr,
                        onPressed: () {
                          Get.toNamed(RouteName.matchingModeScreen, arguments: {
                            'unitId': unitId,
                            'examId': 3,
                            'mainUnitId': mainUnitId,
                            'notification_id': notification_id
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                    // const SizedBox(height: 30),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'quiz_msg'.tr,
                            style: TextStyle(fontSize: 15, height: 2),
                          ),
                          // Add other widgets here if needed
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularCountdownWidget extends StatelessWidget {
  final int daysLeft; // Add the daysLeft parameter
  final int total;
  const CircularCountdownWidget(
      {super.key, required this.daysLeft, required this.total});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circle with dynamic background color based on daysLeft
        Container(
          width: buttonSize, // Same size as progress indicator
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: daysLeft == 0
                ? const Color(0xFFF8EF1E)
                : const Color(0xFFBC120F), // Red background for other cases
          ),
        ),
        SizedBox(
          width: buttonSize, // Adjusted size for progress indicator
          height: buttonSize,
          child: CircularProgressIndicator(
            value: total / 8, // Dynamic value based on the exam_count
            strokeWidth: 10,
            color: Colors.red, // The color of the progress
            backgroundColor: Colors.white, // Background of the circle progress
          ),
        ),
        Center(
          child: Text(
            daysLeft == 0
                ? 'finish'.tr
                : '$daysLeft\n${'days_left'.tr}', // Using .tr for translations
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: daysLeft == 0
                    ? Colors.black
                    : Colors.white), // White text on red background
          ),
        ),
      ],
      // children: [
      //   SizedBox(
      //     width: 120,
      //     height: 120,
      //     child: CircularProgressIndicator(
      //       value: total / 8, // Update the logic based on your countdown
      //       strokeWidth: 10,
      //       color: Colors.red,
      //       backgroundColor: Colors.grey[300],
      //     ),
      //   ),
      //   // Dynamically display daysLeft in the Text widget
      //   Text(
      //     '$daysLeft\n${'days_left'.tr}', // Using .tr for translations
      //     textAlign: TextAlign.center,
      //     style: const TextStyle(fontSize: 14, color: Color(0xFFbc120f)),
      //   ),
      // ],
    );
  }
}

class ModeWidget extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const ModeWidget({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Assign the onTap function
      child: Container(
        width: 70,
        height: 90, // Adjust the height to match the design
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
