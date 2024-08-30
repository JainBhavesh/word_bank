import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:word_bank/components/showConfirmationPopup.dart';

import '../components/button_widget.dart';

class WordPuzzleScreen extends StatefulWidget {
  const WordPuzzleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
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
    // if (inputWord.length != currentWord.length) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please fill out all the letters!')));
    //   return;
    // }
    // if (inputWord.toLowerCase() == currentWord.toLowerCase()) {
    if (currentStep < words.length - 1) {
      setState(() {
        currentStep++;
        currentWord = words[currentStep];
        loadWord();
      });
    } else {
      // Show success popup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _buildSuccessPopup(context);
        },
      );
    }
    // } else {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text('Try Again!')));
    // }
  }

  Widget _buildSuccessPopup(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          EdgeInsets.zero, // Removes default padding around the dialog
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character image
            Image.asset(
              'assets/character.png', // Ensure the correct path to your asset
              height: 150,
            ),
            const SizedBox(height: 20),
            // Container to wrap all text elements with left padding
            Container(
              padding: const EdgeInsets.only(left: 20), // Add left padding
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Congratulatory text
                  Text(
                    'Awesome!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You just finished a test.\nThese are the points you\'ve earned.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display points earned
                  Text(
                    'exp. earned: 12',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'points earned: 12',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Back to home button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonWidget(
                label: 'Back to home',
                icon: Icons.home,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop();
                },
              ),
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
        title: const Text(
          '38812',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              // Edit action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Progress indicator (EasyStepper)
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // Adjust margin to control spacing
                child: EasyStepper(
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
              ),
              const SizedBox(height: 20),
              Text(
                '$currentWord (noun)',
                style: const TextStyle(
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
                    width: 45,
                    height: 45, // Adjusted to be square
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        setState(() {});
                        if (value.isNotEmpty &&
                            index < currentWord.length - 1) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index - 1]);
                        }
                      },
                      onSubmitted: (value) {
                        if (index == currentWord.length - 1) {
                          checkWord();
                        }
                      },
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: currentWord.split('').map((letter) {
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
      ),
    );
  }
}
