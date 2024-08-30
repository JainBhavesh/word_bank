import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/word_list_popup.dart';
import 'package:word_bank/routes/routes_name.dart';

import '../components/button_widget.dart';
import '../components/showConfirmationPopup.dart';

class ReviewOrTestScreen extends StatefulWidget {
  const ReviewOrTestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReviewOrTestScreenState createState() => _ReviewOrTestScreenState();
}

class _ReviewOrTestScreenState extends State<ReviewOrTestScreen> {
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
            // Handle back button
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
                    _showWordListPopup(); // Call the function here
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CircularCountdownWidget(),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ModeWidget(label: 'Easy mode', count: 3, color: Colors.yellow),
                ModeWidget(label: 'Adv mode', count: 2, color: Colors.orange),
                ModeWidget(label: 'Matching mode', count: 0, color: Colors.red),
                ModeWidget(label: 'Push test', count: 1, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ButtonWidget(
                      label: 'Review',
                      onPressed: () {
                        Get.toNamed(RouteName.reviewScreen);
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Easy mode',
                      onPressed: () {
                        Get.toNamed(RouteName.wordPuzzleScreen);
                        print('Easy mode pressed');
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Advanced mode',
                      onPressed: () {
                        Get.toNamed(RouteName.advanceWordPuzzleScreen);
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      label: 'Matching mode',
                      onPressed: () {
                        Get.toNamed(RouteName.matchingModeScreen);
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
                            title: "delete test?",
                            message: "這次的作答記錄和積分都會取消，確定要離開測驗？",
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
  const CircularCountdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: 22 / 30, // Replace with the actual countdown logic
            strokeWidth: 10,
            color: Colors.red,
            backgroundColor: Colors.grey[300],
          ),
        ),
        const Text(
          '22\nDays left',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ],
    );
  }
}

class ModeWidget extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const ModeWidget({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 90, // Adjust the width to match the design
      // padding: const EdgeInsets.all(10),
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
              fontSize: 12, // Smaller font size to fit within the container
              color: Colors.white,
            ),
            // overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
