import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/view/edit_word.dart';
import 'package:word_bank/view_model/controller/review_test_controller.dart';

class WordListPopup extends StatelessWidget {
  final int unitId; // Accept unitId
  final ReviewTestController reviewTestController =
      Get.put(ReviewTestController());

  WordListPopup({super.key, required this.unitId}) {
    reviewTestController.getUnitWordsList(unit_id: unitId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (reviewTestController.isLoading.value) {
          // Show a loading spinner while the data is being fetched
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (reviewTestController.wordsUnitList.isEmpty) {
          // Show a message when there are no words
          return const Center(
            child: Text('No words available.'),
          );
        } else {
          // Display the list of words once loaded
          final words = reviewTestController.wordsUnitList;

          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'word_list'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: words.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final word = words[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(word['english_name']), // Display English name
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (String value) {
                          if (value == 'edit') {
                            _navigateToEditWordScreen(context, word, unitId);
                          } else if (value == 'delete') {
                            reviewTestController
                                .deletWord(id: word['id'])
                                .then((_) {
                              reviewTestController.getUnitWordsList(
                                  unit_id: unitId);
                            }); // Correctly pass word ID
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('edit_word'.tr),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text(
                                'delete_word'.tr,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  void _navigateToEditWordScreen(
      BuildContext context, Map<String, dynamic> word, unit_id) {
    String chineseWord = word['chinese_name'];
    String englishWord = word['english_name'];
    int word_id = word['id'];
    Set<String> selectedCategories = Set.from(word['type']); // Get word types
    print("unitId===>$unit_id");
    print("word_id===>$word_id");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditWordScreen(
            chineseWord: chineseWord,
            englishWord: englishWord,
            selectedCategories: selectedCategories,
            word_id: word_id,
            unit_id: unit_id),
      ),
    );
  }
}
