import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';

import '../components/button_widget.dart';
import '../components/showConfirmationPopup.dart';
import '../routes/routes_name.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/review_test_controller.dart';

class AdvanceWordPuzzleScreen extends StatefulWidget {
  const AdvanceWordPuzzleScreen({super.key});

  @override
  _AdvanceWordPuzzleScreenState createState() =>
      _AdvanceWordPuzzleScreenState();
}

class _AdvanceWordPuzzleScreenState extends State<AdvanceWordPuzzleScreen> {
  int currentStep = 0;
  final ReviewTestController reviewTestController =
      Get.put(ReviewTestController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  bool isError = false; // To show error feedback
  late int unitId;
  late int examId;
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
    reviewTestController.exam(unit_id: unitId, exam_id: examId).then((_) {
      loadWord();
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    reviewTestController.examData.clear(); // Clear exam data when leaving
    super.dispose();
  }

  void loadWord() {
    // Clear previous controllers and focus nodes
    controllers.clear();
    focusNodes.clear();

    // Ensure examData is available and within bounds
    if (reviewTestController.examData.isNotEmpty &&
        currentStep < reviewTestController.examData.length) {
      String currentWord = reviewTestController.examData[currentStep]["ans"];
      controllers =
          List.generate(currentWord.length, (index) => TextEditingController());
      focusNodes = List.generate(currentWord.length, (index) => FocusNode());
    }
  }

  void checkWord() async {
    if (reviewTestController.examData.isNotEmpty) {
      String correctAnswer = reviewTestController.examData[currentStep]["ans"];
      String inputWord =
          controllers.map((controller) => controller.text).join();

      // Ensure all letters are filled
      if (inputWord.length != correctAnswer.length) {
        Get.snackbar('', 'Please fill out all the letters!',
            snackPosition: SnackPosition.TOP);
        return;
      }

      // Check if the input matches the correct answer
      if (inputWord.toLowerCase() == correctAnswer.toLowerCase()) {
        if (currentStep < reviewTestController.examData.length - 1) {
          setState(() {
            currentStep++;
            Get.snackbar('', 'Correct Answer.',
                snackPosition: SnackPosition.TOP);
            loadWord();
          });
        } else {
          // User has completed the last word
          Get.snackbar('', 'Congratulations! All words completed.',
              snackPosition: SnackPosition.TOP);

          // Call gameResult API after the last word is completed
          await reviewTestController.gameResult(
              unit_id: unitId,
              exam_id: examId,
              notification_id: notification_id);

          // Show success dialog after API call
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return _buildSuccessPopup(context);
            },
          );
        }
      } else {
        // Show wrong answer message
        Get.snackbar('', 'Wrong Answer.', snackPosition: SnackPosition.TOP);
      }
    }
  }

  Widget _buildSuccessPopup(BuildContext context) {
    print("unitId===>$unitId");
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'advanced_mode'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: SafeArea(
        child: Obx(() {
          if (reviewTestController.examData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentStep >= reviewTestController.examData.length) {
            return const Center(
              child: Text('No more data available'),
            );
          }
          String currentWord =
              reviewTestController.examData[currentStep]["ans"];
          String chineseName =
              reviewTestController.examData[currentStep]["chinese_name"];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EasyStepper(
                    internalPadding: 0,
                    activeStep: currentStep,
                    stepShape: StepShape.circle,
                    stepBorderRadius: 10,
                    stepRadius: 10,
                    finishedStepBorderColor: Colors.grey,
                    finishedStepTextColor: Colors.black,
                    finishedStepBackgroundColor: Colors.grey,
                    activeStepIconColor: Colors.white,
                    activeStepBorderColor: Colors.red,
                    activeStepBackgroundColor: Colors.red,
                    steps: List.generate(
                        reviewTestController.examData.length,
                        (index) => EasyStep(
                              title: '',
                              activeIcon: Icon(Icons.circle,
                                  color: index == currentStep
                                      ? Colors.red
                                      : Colors.grey),
                              icon:
                                  const Icon(Icons.circle, color: Colors.grey),
                            )),
                    onStepReached: (index) {},
                  ),
                  const SizedBox(height: 30),
                  const Icon(Icons.volume_up, size: 30),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '$chineseName (${'noun'.tr})',
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(currentWord.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 45,
                          height: 45,
                          child: TextField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  index < currentWord.length - 1) {
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index - 1]);
                              }
                            },
                            decoration: const InputDecoration(
                              counterText: '',
                              border: UnderlineInputBorder(),
                            ),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ButtonWidget(
                      label: 'check'.tr,
                      icon: Icons.check,
                      textColor: Colors.white,
                      onPressed: () {
                        checkWord();
                      },
                    ),
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
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
