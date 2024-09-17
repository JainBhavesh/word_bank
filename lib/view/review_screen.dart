import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/controller/review_test_controller.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late int unitId;
  final ReviewTestController reviewTestController =
      Get.put(ReviewTestController());
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    unitId = arguments['unitId'] ?? 0;
    reviewTestController.getReview(unit_id: unitId); // Fetching review data
  }

  void _next() {
    if (currentIndex < reviewTestController.reviewData.length - 1) {
      setState(() {
        currentIndex++;
        // Clear AI content when navigating to the next word
        reviewTestController.aiData.value = {};
      });
    }
  }

  void _prev() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        // Clear AI content when navigating to the previous word
        reviewTestController.aiData.value = {};
      });
    }
  }

  void _quitReview() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
              'Review ${currentIndex + 1}/${reviewTestController.reviewData.length}');
        }),
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

        if (reviewTestController.reviewData.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final content = reviewTestController.reviewData[currentIndex];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    content['english_word'] ?? '',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                      Icons.volume_up), // Placeholder for pronunciation icon
                  const SizedBox(height: 10),
                  Text(
                    content['chinese_word'] ?? '',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      reviewTestController.aiDataGenerate(
                          word: content['english_word']);
                    },
                    icon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'AI content',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (content['english_sentence'] != null) ...[
                Text(
                  content['english_sentence']!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  content['chinese_sentence']!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
              // Spacer between the content and AI-generated part
              const SizedBox(height: 20),
              Obx(() {
                // Access the underlying Map using `value` and then check if it is not empty
                if (reviewTestController.aiData.value.isNotEmpty) {
                  final aiContent = reviewTestController.aiData.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(), // Divider to separate the sections
                      const Text(
                        "AI Generated Content:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Word: ${aiContent['word'] ?? ''}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "English: ${aiContent['english_sentence'] ?? ''}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Chinese: ${aiContent['chinese_sentence'] ?? ''}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink(); // Hide if the data is empty
                }
              }),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _prev,
                    icon: const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    label: const Text('Prev',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _quitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  currentIndex == reviewTestController.reviewData.length - 1
                      ? '完成複習'
                      : 'Quit review',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
