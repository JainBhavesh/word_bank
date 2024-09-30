import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/controller/review_test_controller.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

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

  // New method to handle AI content
  void _generateAIContent() {
    final content = reviewTestController.reviewData[currentIndex];
    reviewTestController
        .aiDataGenerate(word: content['english_word'])
        .then((_) {
      // Check if AI content is generated
      if (reviewTestController.aiData.value['english_sentence'] != null &&
          reviewTestController.aiData.value['chinese_sentence'] != null) {
        // Add the AI-generated content to the current reviewData entry
        reviewTestController.reviewData[currentIndex]['english_sentence'] =
            reviewTestController.aiData.value['english_sentence'];
        reviewTestController.reviewData[currentIndex]['chinese_sentence'] =
            reviewTestController.aiData.value['chinese_sentence'];
        // Optionally, call setState to rebuild the UI
        setState(() {});
      }
    });
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
        print("review data${reviewTestController.reviewData}");
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
                    onPressed: _generateAIContent, // Updated to call new method
                    icon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    label: Text(
                      'ai_content'.tr,
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
                    label:
                        Text('prev'.tr, style: TextStyle(color: Colors.white)),
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
                    child: Text(
                      'next'.tr,
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
                      ? 'complete_review'.tr
                      : 'quit_review'.tr,
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
