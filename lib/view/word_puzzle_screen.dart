// import 'package:flutter/material.dart';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:get/get.dart';
// import 'package:word_bank/components/showConfirmationPopup.dart';
// import '../components/button_widget.dart';
// import '../view_model/controller/review_test_controller.dart';

// class WordPuzzleScreen extends StatefulWidget {
//   const WordPuzzleScreen({super.key});

//   @override
//   _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
// }

// class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
//   int currentStep = 0;
//   final ReviewTestController reviewTestController =
//       Get.put(ReviewTestController());
//   List<TextEditingController> controllers = [];
//   List<FocusNode> focusNodes = [];
//   late int unitId;
//   late int examId;
//   bool isError = false; // To show error feedback

//   @override
//   void initState() {
//     super.initState();
//     final arguments = Get.arguments;
//     unitId = arguments['unitId'] ?? 0;
//     examId = arguments['examId'] ?? 0;
//     reviewTestController.exam(unit_id: unitId, exam_id: examId);
//     reviewTestController.gameResult(unit_id: unitId, exam_id: examId);
//     loadWord();
//     print("daata=======>${reviewTestController.easyExamData}");
//   }

//   void loadWord() {
//     controllers.clear();
//     focusNodes.clear();

//     // Ensure that examData is not empty before proceeding
//     if (reviewTestController.easyExamData.isEmpty) {
//       // Handle the case when no exam data is available
//       print('No exam data available');
//       return;
//     }

//     // Get the current shuffled word from examData
//     String currentWord =
//         reviewTestController.easyExamData[currentStep]["shuffle_english_name"];

//     controllers = List.generate(currentWord.length, (index) {
//       TextEditingController controller = TextEditingController();
//       return controller;
//     });
//     focusNodes = List.generate(currentWord.length, (index) => FocusNode());

//     // Clear error state
//     setState(() {
//       isError = false;
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     for (var node in focusNodes) {
//       node.dispose();
//     }

//     // Optionally reset or remove the controller if needed
//     // Get.delete<ReviewTestController>();

//     super.dispose();
//   }

//   void checkWord() {
//     // Get the correct answer for the current step
//     String correctAnswer =
//         reviewTestController.easyExamData[currentStep]["ans"];

//     // Get user input
//     String inputWord = controllers.map((controller) => controller.text).join();

//     if (inputWord == correctAnswer) {
//       // Answer is correct, move to the next word
//       if (currentStep < reviewTestController.easyExamData.length - 1) {
//         setState(() {
//           currentStep++;
//           loadWord();
//         });
//         setState(() {
//           currentStep++;
//           Get.snackbar('', 'Correct Answer.', snackPosition: SnackPosition.TOP);
//           loadWord();
//         });
//       } else {
//         // Show success popup if all words are solved
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return _buildSuccessPopup(context);
//           },
//         );
//       }
//     } else {
//       Get.snackbar('', 'Wrong Answer.', snackPosition: SnackPosition.TOP);
//       // Set error state to true to show error message
//       setState(() {
//         isError = true;
//       });
//     }
//   }

//   Widget _buildSuccessPopup(BuildContext context) {
//     // Access the earned_point and total from the gameResultData
//     final earnedPoint =
//         reviewTestController.gameResultData['earned_point'] ?? 0;
//     final totalPoints = reviewTestController.gameResultData['total'] ?? 0;

//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               'assets/images/splash_image.png', // Ensure this path is correct
//               width: 100,
//               height: 100,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Awesome!',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'You just finished the test.\nHere are the points you\'ve earned.',
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             // Dynamically display earned points and total
//             Text(
//               'EXP earned: $earnedPoint', // Display earned points
//               style: const TextStyle(fontSize: 18),
//             ),
//             Text(
//               'Total points: $totalPoints', // Display total points
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 30),
//             ButtonWidget(
//               label: 'Back to home',
//               icon: Icons.home,
//               backgroundColor: Colors.black,
//               textColor: Colors.white,
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Close the screen
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Check if examData is null or empty before rendering the UI
//     if (reviewTestController.easyExamData == null ||
//         reviewTestController.easyExamData.isEmpty) {
//       // Show a loading indicator or error message if data is not available
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Easy Word Puzzle'),
//           backgroundColor: Colors.white,
//           elevation: 0,
//         ),
//         body: Center(
//           child:
//               CircularProgressIndicator(), // Loading spinner while data is being fetched
//         ),
//       );
//     }

//     // If data is available, continue building the UI
//     String currentWord =
//         reviewTestController.easyExamData[currentStep]["shuffle_english_name"];
//     String chineseName =
//         reviewTestController.easyExamData[currentStep]["chinese_name"];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Word Puzzle',
//           style: TextStyle(color: Colors.black, fontSize: 18),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(5.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // Progress indicator
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 child: EasyStepper(
//                   internalPadding: 0,
//                   activeStep: currentStep,
//                   stepShape: StepShape.circle,
//                   stepBorderRadius: 10,
//                   stepRadius: 10,
//                   finishedStepBorderColor: Colors.grey,
//                   finishedStepTextColor: Colors.black,
//                   finishedStepBackgroundColor: Colors.grey,
//                   activeStepIconColor: Colors.white,
//                   activeStepBorderColor: Colors.red,
//                   activeStepBackgroundColor: Colors.red,
//                   showLoadingAnimation: false,
//                   showStepBorder: false,
//                   steps: List.generate(
//                     reviewTestController.easyExamData.length,
//                     (index) => EasyStep(
//                       title: '',
//                       activeIcon: Icon(Icons.circle,
//                           color:
//                               index == currentStep ? Colors.red : Colors.grey),
//                       icon: const Icon(Icons.circle, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Speaker Icon + Chinese Word + (noun)
//               Column(
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.volume_up, // Icon for speaker
//                       size: 40,
//                       color: Colors.grey, // Match the color from the screenshot
//                     ),
//                     onPressed: () {
//                       // Handle speaker button press (e.g., play audio)
//                     },
//                   ),
//                   const SizedBox(height: 10), // Adjust spacing as per design
//                   Text(
//                     '$chineseName (noun)',
//                     style: const TextStyle(
//                       fontSize: 24, // Match the font size from the screenshot
//                       fontWeight: FontWeight.normal, // Tweak as needed
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 30),

//               // Input fields for user to rearrange the shuffled word
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(currentWord.length, (index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     width: 45,
//                     height: 45,
//                     child: TextField(
//                       controller: controllers[index],
//                       focusNode: focusNodes[index],
//                       textAlign: TextAlign.center,
//                       maxLength: 1,
//                       onChanged: (value) {
//                         setState(() {});
//                         if (value.isNotEmpty &&
//                             index < currentWord.length - 1) {
//                           FocusScope.of(context)
//                               .requestFocus(focusNodes[index + 1]);
//                         } else if (value.isEmpty && index > 0) {
//                           FocusScope.of(context)
//                               .requestFocus(focusNodes[index - 1]);
//                         }
//                       },
//                       onSubmitted: (value) {
//                         if (index == currentWord.length - 1) {
//                           checkWord();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: '',
//                         border: OutlineInputBorder(),
//                         errorText: isError && controllers[index].text.isEmpty
//                             ? 'Error'
//                             : null,
//                       ),
//                     ),
//                   );
//                 }),
//               ),

//               const SizedBox(height: 20),

//               // Display the shuffle_english_name letters below the input boxes
//               Wrap(
//                 spacing: 8.0,
//                 runSpacing: 8.0,
//                 children: currentWord.split('').map((letter) {
//                   return Chip(
//                     label: Text(letter.toUpperCase(),
//                         style: const TextStyle(color: Colors.blue)),
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 20),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: ButtonWidget(
//                   label: 'Check',
//                   icon: Icons.check,
//                   textColor: Colors.white,
//                   onPressed: () {
//                     checkWord();
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Show error message if the answer is incorrect
//               if (isError)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: Text(
//                     'Incorrect answer, please try again.',
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               // "Quit test" button
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 80),
//                 child: ButtonWidget(
//                   label: 'Quit test',
//                   icon: Icons.logout,
//                   textColor: Colors.white,
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => ShowConfirmationPopup(
//                         title: "Quit test?",
//                         message: "這次的作答記錄和積分都會取消，確定要離開測驗？",
//                         confirmButtonText: "Confirm & quit",
//                         cancelButtonText: "Cancel",
//                         confirmIcon: Icons.exit_to_app,
//                         onConfirm: () {
//                           Navigator.of(context).pop();
//                         },
//                         onCancel: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
    reviewTestController.gameResult(unit_id: unitId, exam_id: examId);
  }

  void loadWord() {
    controllers.clear();
    focusNodes.clear();

    // Check if data is available
    if (reviewTestController.easyExamData.isEmpty) {
      return;
    }

    String currentWord =
        reviewTestController.easyExamData[currentStep]["shuffle_english_name"];
    controllers =
        List.generate(currentWord.length, (index) => TextEditingController());
    focusNodes = List.generate(currentWord.length, (index) => FocusNode());
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

  void checkWord() {
    String correctAnswer =
        reviewTestController.easyExamData[currentStep]["ans"];
    String inputWord = controllers.map((controller) => controller.text).join();

    if (inputWord == correctAnswer) {
      setState(() {
        currentStep++;
        loadWord();
        isError = false;
      });
      Get.snackbar('', 'Correct Answer.', snackPosition: SnackPosition.TOP);

      if (currentStep >= reviewTestController.easyExamData.length) {
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

      String currentWord = reviewTestController.easyExamData[currentStep]
          ["shuffle_english_name"];
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
                // Progress indicator
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
                  showLoadingAnimation: false,
                  showStepBorder: false,
                  steps: List.generate(
                    reviewTestController.easyExamData.length,
                    (index) => EasyStep(
                      title: '',
                      activeIcon: Icon(Icons.circle,
                          color:
                              index == currentStep ? Colors.red : Colors.grey),
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
                        onSubmitted: (value) {
                          if (index == currentWord.length - 1) {
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
