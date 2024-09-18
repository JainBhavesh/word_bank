import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';

import '../components/button_widget.dart';
import '../components/showConfirmationPopup.dart';
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
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  bool isError = false; // To show error feedback
  late int unitId;
  late int examId;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    examId = arguments['examId'] ?? 0;
    // reviewTestController.exam(
    //     unit_id: unitId, exam_id: examId); // Fetch API data
    // loadWord();
    reviewTestController.gameResult(unit_id: unitId, exam_id: examId);
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

    // Optionally reset or remove the controller if needed
    // Get.delete<ReviewTestController>();

    super.dispose();
  }

  void loadWord() {
    controllers.clear();
    focusNodes.clear();
    // Only load if data is available
    if (reviewTestController.examData.isNotEmpty) {
      print(
          "reviewTestController.examData===>${reviewTestController.examData}");

      String currentWord = reviewTestController.examData[currentStep]
          ["ans"]; // Use the correct word for the puzzle

      controllers =
          List.generate(currentWord.length, (index) => TextEditingController());
      focusNodes = List.generate(currentWord.length, (index) => FocusNode());
    }
  }

  void checkWord() {
    if (reviewTestController.examData.isNotEmpty) {
      String correctAnswer = reviewTestController.examData[currentStep]["ans"];
      String inputWord =
          controllers.map((controller) => controller.text).join();

      if (inputWord.length != correctAnswer.length) {
        Get.snackbar('', 'Please fill out all the letters!',
            snackPosition: SnackPosition.TOP);
        return;
      }

      if (inputWord.toLowerCase() == correctAnswer.toLowerCase()) {
        if (currentStep < reviewTestController.examData.length - 1) {
          setState(() {
            currentStep++;
            Get.snackbar('', 'Correct Answer.',
                snackPosition: SnackPosition.TOP);
            loadWord();
          });
        } else {
          Get.snackbar('', 'Congratulations! All words completed.',
              snackPosition: SnackPosition.TOP);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return _buildSuccessPopup(context);
            },
          );
        }
      } else {
        Get.snackbar('', 'Wrong Answer.', snackPosition: SnackPosition.TOP);
      }
    }
  }

  Widget _buildSuccessPopup(BuildContext context) {
    // Access the earned_point and total from the gameResultData
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
            Image.asset(
              'assets/images/splash_image.png', // Ensure this path is correct
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Awesome!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'You just finished the test.\nHere are the points you\'ve earned.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Dynamically display earned points and total
            Text(
              'EXP earned: $earnedPoint', // Display earned points
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Total points: $totalPoints', // Display total points
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ButtonWidget(
              label: 'Back to home',
              icon: Icons.home,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the screen
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the data is available
    if (reviewTestController.examData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Advance puzzle'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child:
              CircularProgressIndicator(), // Show loading indicator while data is being fetched
        ),
      );
    }

    String currentWord =
        reviewTestController.examData[currentStep]["ans"]; // Correct answer
    String chineseName = reviewTestController.examData[currentStep]
        ["chinese_name"]; // Chinese word

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          true, // Ensure the layout resizes when the keyboard appears
      appBar: AppBar(
        title: const Text(
          'Advance Puzzle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress stepper at the top
              EasyStepper(
                internalPadding: 0,
                activeStep: currentStep,
                stepShape: StepShape.circle,
                stepBorderRadius: 10,
                stepRadius: 10, // Reduce step size
                finishedStepBorderColor: Colors.grey,
                finishedStepTextColor: Colors.black,
                finishedStepBackgroundColor: Colors.grey,
                activeStepIconColor: Colors.white,
                activeStepBorderColor: Colors.red,
                activeStepBackgroundColor: Colors.red,
                showLoadingAnimation: false,
                showStepBorder: false,
                steps: List.generate(
                    reviewTestController.examData.length,
                    (index) => EasyStep(
                          title: '', // Empty title for minimalistic stepper
                          activeIcon: Icon(Icons.circle,
                              color: index == currentStep
                                  ? Colors.red
                                  : Colors.grey),
                          icon: const Icon(Icons.circle, color: Colors.grey),
                        )),
                onStepReached: (index) {},
              ),

              const SizedBox(height: 30),

              // Speaker icon and word (Chinese + noun)
              const Icon(Icons.volume_up, size: 30),
              const SizedBox(height: 10),
              Text(
                '$chineseName (noun)', // Example Chinese word and part of speech
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Input fields (word puzzle)
              Row(
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
                        border:
                            UnderlineInputBorder(), // Use underline as per screenshot
                      ),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color:
                            Colors.black, // Match the color in the screenshot
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // "Check" button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ButtonWidget(
                  label: 'Check',
                  icon: Icons.check,
                  textColor: Colors.white,
                  onPressed: () {
                    checkWord();
                  },
                ),
              ),

              const SizedBox(height: 20),

              // "Quit test" button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ButtonWidget(
                  label: 'Quit test',
                  icon: Icons.logout,
                  textColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ShowConfirmationPopup(
                        title: "Quit test?",
                        message: "這次的作答記錄和積分都會取消，確定要離開測驗？",
                        confirmButtonText: "Confirm & quit",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
