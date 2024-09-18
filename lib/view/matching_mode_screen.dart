// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:word_bank/components/button_widget.dart';

// import '../view_model/controller/review_test_controller.dart';

// class MatchingModeScreen extends StatefulWidget {
//   const MatchingModeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MatchingModeScreenState createState() => _MatchingModeScreenState();
// }

// class _MatchingModeScreenState extends State<MatchingModeScreen> {
//   final ReviewTestController reviewTestController =
//       Get.put(ReviewTestController());
//   final List<String> words = [
//     'accord',
//     'acceptable',
//     'accident',
//     'account',
//     'accurate'
//   ];
//   final List<String> meanings = [
//     '[n]一致、符合',
//     '[a]可接受的, 合意的',
//     '[n]意外事件,事故',
//     '[n]計算,帳目',
//     '[a]正確的,精確的'
//   ];

//   List<bool> selectedWords = [];
//   List<bool> selectedMeanings = [];
//   int? selectedWordIndex;
//   int? selectedMeaningIndex;
//   late int unitId;
//   late int examId;

//   @override
//   void initState() {
//     super.initState();
//     selectedWords = List<bool>.filled(words.length, false);
//     selectedMeanings = List<bool>.filled(meanings.length, false);
//     final arguments = Get.arguments;
//     unitId = arguments['unitId'] ?? 0;
//     examId = arguments['examId'] ?? 0;
//     reviewTestController.exam(
//         unit_id: unitId, exam_id: examId); // Fetch API data
//   }

//   void _onWordSelected(int index) {
//     setState(() {
//       if (selectedWordIndex != null) {
//         selectedWords[selectedWordIndex!] = false;
//       }
//       selectedWordIndex = index;
//       selectedWords[index] = true;
//       _checkMatch();
//     });
//   }

//   void _onMeaningSelected(int index) {
//     setState(() {
//       if (selectedMeaningIndex != null) {
//         selectedMeanings[selectedMeaningIndex!] = false;
//       }
//       selectedMeaningIndex = index;
//       selectedMeanings[index] = true;
//       _checkMatch();
//     });
//   }

//   void _checkMatch() {
//     if (selectedWordIndex != null && selectedMeaningIndex != null) {
//       if (selectedWordIndex == selectedMeaningIndex) {
//         // Match found
//         selectedWords[selectedWordIndex!] = false;
//         selectedMeanings[selectedMeaningIndex!] = false;
//         selectedWordIndex = null;
//         selectedMeaningIndex = null;

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Match Found!')),
//         );
//       } else {
//         // No match
//         selectedWords[selectedWordIndex!] = false;
//         selectedMeanings[selectedMeaningIndex!] = false;
//         selectedWordIndex = null;
//         selectedMeaningIndex = null;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Matching Mode'),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 16.0),
//             child: Center(
//               child: Text(
//                 '38812',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   // English words column
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: words.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: selectedWords[index]
//                                   ? Colors.grey
//                                   : Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             onPressed: () => _onWordSelected(index),
//                             child: Text(words[index],
//                                 style: const TextStyle(color: Colors.white)),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   // Chinese meanings column
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: meanings.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: selectedMeanings[index]
//                                   ? Colors.grey
//                                   : Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             onPressed: () => _onMeaningSelected(index),
//                             child: Text(meanings[index],
//                                 style: const TextStyle(color: Colors.white)),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: ButtonWidget(
//                 label: 'Quit test',
//                 icon: Icons.logout,
//                 textColor: Colors.white,
//                 onPressed: () {
//                   print('Delete unit pressed');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/button_widget.dart';
import '../components/showConfirmationPopup.dart';
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

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    examId = arguments['examId'] ?? 0;
    reviewTestController.exam(
        unit_id: unitId, exam_id: examId); // Fetch API data
    reviewTestController.gameResult(unit_id: unitId, exam_id: examId);

    // Shuffle lists after data is fetched
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shuffleLists();
    });
  }

  void _shuffleLists() {
    // Get the English words and Chinese meanings
    words = reviewTestController.matchingModeData
        .map<String>((item) => item['shuffle_english_name'].toString())
        .toList();

    meanings = reviewTestController.matchingModeData
        .map<String>((item) => item['chinese_name'].toString())
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

  void _checkMatch() {
    if (selectedWordIndex != null && selectedMeaningIndex != null) {
      int originalWordIndex = originalWordIndexes[selectedWordIndex!];
      String correctChineseName = reviewTestController
          .matchingModeData[originalWordIndex]['ans']['chinese_name'];
      String selectedChineseName = meanings[selectedMeaningIndex!];

      if (selectedChineseName == correctChineseName) {
        Get.snackbar('Correct', 'You found a correct match!',
            backgroundColor: Colors.green, colorText: Colors.white);

        // Mark both items as correct
        setState(() {
          correctWords[selectedWordIndex!] = true;
          correctMeanings[selectedMeaningIndex!] = true;
        });

        // Check if all answers are correct
        allAnswersCorrect = correctWords.every((element) => element) &&
            correctMeanings.every((element) => element);
      } else {
        Get.snackbar('Wrong', 'This is not the correct match.',
            backgroundColor: Colors.red, colorText: Colors.white);

        // Reset selected items if wrong
        setState(() {
          selectedWords[selectedWordIndex!] = false;
          selectedMeanings[selectedMeaningIndex!] = false;
        });

        // Reset allAnswersCorrect since a wrong match was made
        allAnswersCorrect = false;
      }

      // Reset selected indices
      selectedWordIndex = null;
      selectedMeaningIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Mode'),
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
      body: Obx(() {
        if (reviewTestController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // The lists are shuffled, so we don't need to regenerate them

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // English words column (shuffle_english_name)
                    Expanded(
                      child: ListView.builder(
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: correctWords[index]
                                    ? Colors.green // Correct match color
                                    : selectedWords[index]
                                        ? Colors.blue // Selected item color
                                        : Colors.black, // Default color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: selectedWords[index] ||
                                      correctWords[index]
                                  ? null // Disable if already selected or correct
                                  : () => _onWordSelected(index),
                              child: Text(words[index],
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Chinese meanings column (chinese_name)
                    Expanded(
                      child: ListView.builder(
                        itemCount: meanings.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: correctMeanings[index]
                                    ? Colors.green // Correct match color
                                    : selectedMeanings[index]
                                        ? Colors.orange // Selected item color
                                        : Colors.black, // Default color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: selectedMeanings[index] ||
                                      correctMeanings[index]
                                  ? null // Disable if already selected or correct
                                  : () => _onMeaningSelected(index),
                              child: Text(meanings[index],
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
                child: allAnswersCorrect // Check if all answers are correct
                    ? ButtonWidget(
                        label: 'Check',
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
                    : Container(), // Don't show the button if not all answers are correct
              ),
              const SizedBox(height: 20),
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
