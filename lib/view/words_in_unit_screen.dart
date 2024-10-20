import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/button_widget.dart';
import 'package:word_bank/view_model/controller/word_in_unit_controller.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/word_controller.dart';

class WordsInUnitScreen extends StatefulWidget {
  final int wordbankId; // Pass the wordbankId here

  const WordsInUnitScreen({super.key, required this.wordbankId});

  @override
  // ignore: library_private_types_in_public_api
  _WordsInUnitScreenState createState() => _WordsInUnitScreenState();
}

class _WordsInUnitScreenState extends State<WordsInUnitScreen> {
  late final WordsController wordsController;
  final WordInUnitController wordInUnitController =
      Get.put(WordInUnitController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    wordsController = Get.put(WordsController(wordbankId: widget.wordbankId));
    // _selectedWordCount = wordsController.wordList.length;
    _selectedWordCount = 6;
  }

  int _selectedWordCount = 0;
  final int _minWordCount = 6;
  final int _maxWordCount = 12;

  void _incrementWordCount() {
    if (_selectedWordCount < _maxWordCount) {
      setState(() {
        _selectedWordCount++;
      });
    }
  }

  void _decrementWordCount() {
    if (_selectedWordCount > _minWordCount) {
      setState(() {
        _selectedWordCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'word_count_header'.tr,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, size: 30),
                  onPressed: _decrementWordCount,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_selectedWordCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right, size: 30),
                  onPressed: _incrementWordCount,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'word_count_message'.tr,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ButtonWidget(
                label: 'confirm'.tr,
                icon: Icons.logout,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  print("Selected $_selectedWordCount words");

                  if (wordsController.wordList.length >= 6) {
                    if (_selectedWordCount <= wordsController.wordList.length) {
                      int count = _selectedWordCount;
                      wordInUnitController.createUnit(
                          count: count, wordbankId: widget.wordbankId);
                      print('true----------------');
                    } else {
                      Navigator.of(context).pop();
                      print('false----------------');
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (wordsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (wordsController.wordList.isEmpty) {
                  return const Center(child: Text("No words available."));
                }

                return ListView.separated(
                  itemCount: wordsController.wordList.length,
                  itemBuilder: (context, index) {
                    var word = wordsController.wordList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        word['english_name'], // Display the english_name
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
