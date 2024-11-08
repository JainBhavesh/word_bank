import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/button_widget.dart';
import '../components/showConfirmationPopup.dart';
import '../routes/routes_name.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/review_test_controller.dart';
import 'dart:math';

class MatchingModeScreen extends StatefulWidget {
  const MatchingModeScreen({super.key});

  @override
  _MatchingModeScreenState createState() => _MatchingModeScreenState();
}

class _MatchingModeScreenState extends State<MatchingModeScreen> {
  final ReviewTestController reviewTestController =
      Get.put(ReviewTestController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  List<bool> selectedWords = [];
  List<bool> selectedMeanings = [];
  List<bool> correctWords = [];
  List<bool> correctMeanings = [];
  int? selectedWordIndex;
  int? selectedMeaningIndex;
  late int unitId;
  late int examId;
  List<String> words = [];
  List<String> meanings = [];
  List<int> originalWordIndexes = [];
  List<int> originalMeaningIndexes = [];
  bool allAnswersCorrect = false;
  late int notification_id;
  late int mainUnitId;
  late int daysLeft;
  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    examId = arguments['examId'] ?? 0;
    notification_id = arguments['notification_id'] ?? 0;
    mainUnitId = arguments['mainUnitId'];
    daysLeft = arguments['daysLeft'] ?? 0;
    // Fetch data
    reviewTestController.exam(unit_id: unitId, exam_id: examId).then((_) {
      if (reviewTestController.matchingModeData.isNotEmpty) {
        _shuffleLists(); // Call shuffle only after data is loaded
      }
    });
  }

  void _shuffleLists() {
    // Get the Chinese names and shuffled English names
    meanings = reviewTestController.matchingModeData
        .map<String>((item) => item['chinese_name'].toString())
        .toList();

    words = reviewTestController.matchingModeData
        .map<String>((item) => item['shuffle_english_name'].toString())
        .toList();

    // Store the original indexes for correct answer checking
    originalWordIndexes = List<int>.generate(words.length, (index) => index);
    originalMeaningIndexes =
        List<int>.generate(meanings.length, (index) => index);

    // Shuffle the lists
    words.shuffle(Random());
    meanings.shuffle(Random());

    // Initialize selection and correctness lists
    selectedWords = List<bool>.filled(words.length, false);
    selectedMeanings = List<bool>.filled(meanings.length, false);
    correctWords = List<bool>.filled(words.length, false);
    correctMeanings = List<bool>.filled(meanings.length, false);

    setState(() {});
  }

  void _onWordSelected(int index) {
    setState(() {
      if (selectedWordIndex != null) {
        selectedWords[selectedWordIndex!] = false;
      }
      selectedWordIndex = index;
      selectedWords[index] = true;
      _checkMatch();
    });
  }

  void _onMeaningSelected(int index) {
    setState(() {
      if (selectedMeaningIndex != null) {
        selectedMeanings[selectedMeaningIndex!] = false;
      }
      selectedMeaningIndex = index;
      selectedMeanings[index] = true;
      _checkMatch();
    });
  }

  void _checkMatch() async {
    if (selectedWordIndex != null && selectedMeaningIndex != null) {
      // Get the selected Chinese name and selected shuffled English name
      String selectedChineseName = meanings[selectedMeaningIndex!];
      String selectedShuffledEnglishName = words[selectedWordIndex!];

      // Find the original entry that matches the selected Chinese name
      var matchedEntry = reviewTestController.matchingModeData.firstWhere(
        (item) => item['chinese_name'] == selectedChineseName,
        orElse: () => null,
      );

      if (matchedEntry != null) {
        // Get the correct English name from the `ans` object
        String correctEnglishName = matchedEntry['ans']['english_name'];

        // Now compare the selected shuffled English name with the correct one from ans
        if (selectedShuffledEnglishName == correctEnglishName) {
          // It's a correct match!
          Get.snackbar('Correct', 'You found a correct match!',
              backgroundColor: Colors.green, colorText: Colors.white);

          setState(() {
            correctWords[selectedWordIndex!] = true;
            correctMeanings[selectedMeaningIndex!] = true;
          });

          // Check if all answers are correct
          allAnswersCorrect = correctWords.every((element) => element) &&
              correctMeanings.every((element) => element);

          // If all answers are correct, call gameResult API
          if (allAnswersCorrect) {
            await reviewTestController.gameResult(
                unit_id: unitId,
                exam_id: examId,
                notification_id: notification_id);

            // Show success popup after the API call
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return _buildSuccessPopup(context);
              },
            );
          }
        } else {
          // It's a wrong match
          Get.snackbar('Wrong', 'This is not the correct match.',
              backgroundColor: Colors.red, colorText: Colors.white);

          // Reset selected state if the answer is wrong
          setState(() {
            selectedWords[selectedWordIndex!] = false;
            selectedMeanings[selectedMeaningIndex!] = false;
          });

          allAnswersCorrect = false;
        }
      }

      // Reset the selected indices
      selectedWordIndex = null;
      selectedMeaningIndex = null;
    }
  }

  Widget _buildSuccessPopup(BuildContext context) {
    final earnedPoint =
        reviewTestController.gameResultData['earned_point'] ?? 0;
    final totalPoints = reviewTestController.gameResultData['total'] ?? 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/earn_point.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    0.3, // 30% of screen height
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'awesome'.tr,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'game_message'.tr,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '${'exp_earned'.tr} $earnedPoint',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '${'total_earned'.tr} $totalPoints',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ButtonWidget(
              label: 'back_to_home'.tr,
              icon: Icons.home,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                notificationController.getTotalCount();
                notificationController.getTodayTask();
                if (mainUnitId == 0) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Get.offNamed(RouteName.reviewOrTestScreen, arguments: {
                    'unitId': unitId,
                    'daysLeft': daysLeft,
                    'mainUnitId': mainUnitId
                  });
                } else {
                  if (reviewTestController.gameResultData['exam'] == 'finish') {
                    Future.delayed(Duration.zero, () {
                      Get.offAndToNamed(RouteName.unitSelector,
                          arguments: {'id': mainUnitId});
                    });
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('matching_mode'.tr),
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
      body: Obx(() {
        if (reviewTestController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if matchingModeData is empty
        if (reviewTestController.matchingModeData.isEmpty) {
          return const Center(
            child: Text('No data available. Please try again later.'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Chinese meanings column
                    Expanded(
                      child: ListView.builder(
                        itemCount: meanings.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: correctMeanings[index]
                                    ? Colors.green
                                    : selectedMeanings[index]
                                        ? Colors.orange
                                        : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: selectedMeanings[index] ||
                                      correctMeanings[index]
                                  ? null
                                  : () => _onMeaningSelected(index),
                              child: Text(meanings[index],
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Shuffle English names column
                    Expanded(
                      child: ListView.builder(
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: correctWords[index]
                                    ? Colors.green
                                    : selectedWords[index]
                                        ? Colors.blue
                                        : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed:
                                  selectedWords[index] || correctWords[index]
                                      ? null
                                      : () => _onWordSelected(index),
                              child: Text(words[index],
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: allAnswersCorrect
                    ? ButtonWidget(
                        label: 'check'.tr,
                        icon: Icons.check,
                        textColor: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return _buildSuccessPopup(context);
                            },
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ButtonWidget(
                  label: 'quit_test'.tr,
                  icon: Icons.logout,
                  textColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ShowConfirmationPopup(
                        title: "quit_test".tr,
                        message: "這次的作答記錄和積分都會取消，確定要離開測驗？",
                        confirmButtonText: "confirm_and_quit".tr,
                        cancelButtonText: "cancel".tr,
                        confirmIcon: Icons.exit_to_app,
                        onConfirm: () {
                          Navigator.of(context).pop();
                          Get.back();
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
