import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/word_list_popup.dart';
import 'package:word_bank/routes/routes_name.dart';
import '../components/button_widget.dart';
import '../components/showConfirmationPopup.dart';
import '../view_model/controller/review_test_controller.dart';

class ReviewOrTestScreen extends StatefulWidget {
  const ReviewOrTestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReviewOrTestScreenState createState() => _ReviewOrTestScreenState();
}

class _ReviewOrTestScreenState extends State<ReviewOrTestScreen> {
  final List<Color> colors = [
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.blue
  ];

  late final ReviewTestController _controller;
  late int unitId;
  late int daysLeft;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ReviewTestController());

    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    daysLeft = arguments['daysLeft'] ?? 0;
    _controller.getExamTypeList();
    print("unitId==>$unitId");
  }

  void _showWordListPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WordListPopup(
          words: [
            'accord',
            'acceptable',
            'accident',
            'account',
            'accurate',
            'ache',
            'achieve',
            'activity',
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review or test'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '38812',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
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
                const Text(
                  'Check words',
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
            CircularCountdownWidget(daysLeft: daysLeft),
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
                    if (examType['name'] == 'easy mode') {
                      onTap = () {
                        Get.toNamed(RouteName.wordPuzzleScreen,
                            arguments: {'unitId': unitId, 'examId': 1});
                      };
                    } else if (examType['name'] == 'advance mode') {
                      onTap = () {
                        Get.toNamed(RouteName.advanceWordPuzzleScreen,
                            arguments: {'unitId': unitId, 'examId': 2});
                      };
                    } else if (examType['name'] == 'matching mode') {
                      onTap = () {
                        Get.toNamed(RouteName.matchingModeScreen,
                            arguments: {'unitId': unitId, 'examId': 3});
                      };
                    }

                    return ModeWidget(
                      label: examType['name'] ?? 'Unknown',
                      count: examType['count'] ?? 0,
                      color: colors[
                          index % colors.length], // Assign color based on index
                      onTap: onTap,
                    );
                  }).toList(),

                  const ModeWidget(
                      label: 'Push test',
                      count: 1,
                      color: Colors.blue,
                      onTap: null),
                ],
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ButtonWidget(
                      label: 'Review',
                      onPressed: () {
                        Get.toNamed(RouteName.reviewScreen,
                            arguments: {'unitId': unitId});
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Easy mode',
                      onPressed: () {
                        Get.toNamed(RouteName.wordPuzzleScreen,
                            arguments: {'unitId': unitId, 'examId': 1});
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Advanced mode',
                      onPressed: () {
                        Get.toNamed(RouteName.advanceWordPuzzleScreen,
                            arguments: {'unitId': unitId, 'examId': 2});
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Matching mode',
                      onPressed: () {
                        Get.toNamed(RouteName.matchingModeScreen,
                            arguments: {'unitId': unitId, 'examId': 3});
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Delete unit',
                      icon: Icons.logout,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ShowConfirmationPopup(
                            title: "Delete test?",
                            message:
                                "This will cancel your test record and score. Are you sure you want to exit the test?",
                            confirmButtonText: "Confirm & delete",
                            cancelButtonText: "Cancel",
                            confirmIcon: Icons.exit_to_app,
                            onConfirm: () {
                              Navigator.of(context).pop();
                            },
                            onCancel: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
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

  const CircularCountdownWidget({super.key, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: daysLeft / 30, // Update the logic based on your countdown
            strokeWidth: 10,
            color: Colors.red,
            backgroundColor: Colors.grey[300],
          ),
        ),
        // Dynamically display daysLeft in the Text widget
        Text(
          '$daysLeft\nDays left', // Replace the hardcoded value with daysLeft
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, color: Colors.red),
        ),
      ],
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
