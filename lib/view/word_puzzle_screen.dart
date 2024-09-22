import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/showConfirmationPopup.dart';
import '../components/button_widget.dart';
import '../view_model/controller/review_test_controller.dart';

class WordPuzzleScreen extends StatefulWidget {
  const WordPuzzleScreen({super.key});

  @override
  _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
  int currentStep = 0;
  final ReviewTestController reviewTestController =
      Get.put(ReviewTestController());
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  late int unitId;
  late int examId;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    examId = arguments['examId'] ?? 0;

    // Fetch data and then load the first word
    reviewTestController.exam(unit_id: unitId, exam_id: examId).then((_) {
      loadWord();
    });
  }

  void loadWord() {
    controllers.clear();
    focusNodes.clear();

    // Ensure that currentStep is within bounds and data is not empty
    if (reviewTestController.easyExamData.isEmpty ||
        currentStep >= reviewTestController.easyExamData.length) {
      return;
    }

    // Get the correct answer and shuffled word (without spaces)
    String correctAnswer = reviewTestController.easyExamData[currentStep]["ans"]
        .replaceAll(" ", "");
    String shuffledWord = reviewTestController.easyExamData[currentStep]
            ["shuffle_english_name"]
        .replaceAll(" ", "");

    // Generate controllers and focus nodes based on the correct answer length
    controllers =
        List.generate(correctAnswer.length, (index) => TextEditingController());
    focusNodes = List.generate(correctAnswer.length, (index) => FocusNode());

    setState(() {
      isError = false; // Clear error state
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
    super.dispose();
  }

  void checkWord() async {
    // Ensure that easyExamData is not empty and currentStep is within bounds
    if (reviewTestController.easyExamData.isEmpty ||
        currentStep >= reviewTestController.easyExamData.length) {
      return;
    }

    // Retrieve correctAnswer safely
    String correctAnswer = reviewTestController.easyExamData[currentStep]["ans"]
        .replaceAll(" ", "");
    String inputWord = controllers.map((controller) => controller.text).join();

    if (inputWord == correctAnswer) {
      // If the answer is correct, increment currentStep
      currentStep++;

      // Check if there are more steps left
      if (currentStep < reviewTestController.easyExamData.length) {
        // Update the UI state
        setState(() {
          loadWord();
          isError = false;
        });
      } else {
        // Handle the last step (call gameResult outside setState)
        await reviewTestController.gameResult(unit_id: unitId, exam_id: examId);

        // After async work, update UI to show the success popup
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return _buildSuccessPopup(context);
          },
        );
      }

      // Show a success message
      Get.snackbar('', 'Correct Answer.', snackPosition: SnackPosition.TOP);
    } else {
      // Show an error message
      Get.snackbar('', 'Wrong Answer.', snackPosition: SnackPosition.TOP);

      // Update the UI state to show the error
      setState(() {
        isError = true; // Show error
      });
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
            Image.asset('assets/images/splash_image.png',
                width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 20),
            const Text('Awesome!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
                'You just finished the test.\nHere are the points you\'ve earned.',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('EXP earned: $earnedPoint',
                style: const TextStyle(fontSize: 18)),
            Text('Total points: $totalPoints',
                style: const TextStyle(fontSize: 18)),
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
    return Obx(() {
      // Show loading indicator while data is being fetched
      if (reviewTestController.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
              title: const Text('Easy Word Puzzle'),
              backgroundColor: Colors.white,
              elevation: 0),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // Show an empty state if data is still empty
      if (reviewTestController.easyExamData.isEmpty) {
        return Scaffold(
          appBar: AppBar(
              title: const Text('Easy Word Puzzle'),
              backgroundColor: Colors.white,
              elevation: 0),
          body: Center(
            child: Text(
              'No data available. Please try again later.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        );
      }

      // Ensure currentStep is within the bounds of easyExamData
      if (currentStep >= reviewTestController.easyExamData.length) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Easy Word Puzzle'),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
            child: Text(
              'You have completed the test!',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        );
      }

      // Safely access easyExamData using currentStep
      String correctAnswer =
          reviewTestController.easyExamData[currentStep]["ans"];
      String shuffledWord = reviewTestController.easyExamData[currentStep]
              ["shuffle_english_name"]
          .replaceAll(" ", "");
      String chineseName =
          reviewTestController.easyExamData[currentStep]["chinese_name"];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Word Puzzle',
              style: TextStyle(color: Colors.black, fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back()),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // EasyStepper Progress indicator
                EasyStepper(
                  activeStep: currentStep,
                  stepShape: StepShape.circle,
                  stepRadius: 10,
                  finishedStepBorderColor: Colors.grey,
                  finishedStepBackgroundColor: Colors.grey,
                  activeStepIconColor: Colors.white,
                  activeStepBorderColor: Colors.red,
                  activeStepBackgroundColor: Colors.red,
                  steps: List.generate(
                    reviewTestController.easyExamData.length,
                    (index) => EasyStep(
                      title: '',
                      icon: const Icon(Icons.circle, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Speaker Icon + Chinese Word
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up,
                          size: 40, color: Colors.grey),
                      onPressed: () {
                        // Handle speaker button press (e.g., play audio)
                      },
                    ),
                    const SizedBox(height: 10),
                    Text('$chineseName (noun)',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 30),
                // Input fields for rearranging the shuffled word
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(correctAnswer.length, (index) {
                    return Container(
                      width: 45,
                      height: 45,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              index < correctAnswer.length - 1) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index - 1]);
                          }
                        },
                        onSubmitted: (value) {
                          if (index == correctAnswer.length - 1) {
                            checkWord();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                          errorText: isError && controllers[index].text.isEmpty
                              ? 'Error'
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // Display the shuffled letters below the input boxes
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: shuffledWord.split('').map((letter) {
                    return Chip(
                      label: Text(letter.toUpperCase(),
                          style: const TextStyle(color: Colors.blue)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ButtonWidget(
                    label: 'Check',
                    icon: Icons.check,
                    textColor: Colors.white,
                    onPressed: () => checkWord(),
                  ),
                ),
                const SizedBox(height: 20),
                // Show error message if the answer is incorrect
                if (isError)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text('Incorrect answer, please try again.',
                        style: TextStyle(color: Colors.red, fontSize: 16)),
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
    });
  }
}
