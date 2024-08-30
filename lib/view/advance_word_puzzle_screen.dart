import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';

import '../components/button_widget.dart';
import '../components/showConfirmationPopup.dart';

class AdvanceWordPuzzleScreen extends StatefulWidget {
  const AdvanceWordPuzzleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdvanceWordPuzzleScreenState createState() =>
      _AdvanceWordPuzzleScreenState();
}

class _AdvanceWordPuzzleScreenState extends State<AdvanceWordPuzzleScreen> {
  final List<String> words = [
    "apple",
    "banana",
    "orange",
    "grapes",
    "mango",
    "peach",
    "berry",
    "melon",
    "kiwi",
    "lemon"
  ];
  String currentWord = "apple"; // Starting word
  int currentStep = 0;

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    loadWord();
  }

  void loadWord() {
    controllers.clear();
    focusNodes.clear();

    controllers =
        List.generate(currentWord.length, (index) => TextEditingController());
    focusNodes = List.generate(currentWord.length, (index) => FocusNode());
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

  void checkWord() {
    String inputWord = controllers.map((controller) => controller.text).join();
    if (inputWord.length != currentWord.length) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill out all the letters!')));
      return;
    }
    if (inputWord.toLowerCase() == currentWord.toLowerCase()) {
      if (currentStep < words.length - 1) {
        setState(() {
          currentStep++;
          currentWord = words[currentStep];
          loadWord();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Congratulations! All words completed.')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Try Again!')));
    }
  }

  void quitTest() {
    // Handle quit test logic
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '38812',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EasyStepper(
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
                  words.length,
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
            const Icon(Icons.volume_up, size: 30),
            const SizedBox(height: 10),
            const Text(
              '蘋果 (noun)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(currentWord.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
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
            )
          ],
        ),
      ),
    );
  }
}
