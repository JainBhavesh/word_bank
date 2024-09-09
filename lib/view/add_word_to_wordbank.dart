import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/view/words_in_unit_screen.dart';
import '../view_model/controller/add_Word_To_WordbankController.dart';
import '../view_model/controller/word_controller.dart';

class AddWordToWordbankScreen extends StatefulWidget {
  final int wordbankId;

  const AddWordToWordbankScreen({super.key, required this.wordbankId});

  @override
  // ignore: library_private_types_in_public_api
  _AddWordToWordbankScreenState createState() =>
      _AddWordToWordbankScreenState();
}

class _AddWordToWordbankScreenState extends State<AddWordToWordbankScreen> {
  final AddWordToWordbankbankController addWordController =
      Get.put(AddWordToWordbankbankController());

  // Initialize WordsController to fetch the words from the word bank
  late final WordsController wordsController;

  @override
  void initState() {
    super.initState();
    wordsController = Get.put(WordsController(wordbankId: widget.wordbankId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the view adjusts for the keyboard
      appBar: AppBar(
        title: const Text('Add words'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chinese',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: addWordController.chineseController,
                        decoration: InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'English',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: addWordController.englishController,
                        decoration: InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 8.0,
                        children: addWordController.wordTypes.map((type) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: addWordController.selectedTypes[type],
                                onChanged: (value) {
                                  setState(() {
                                    addWordController.selectedTypes[type] =
                                        value!;
                                  });
                                },
                              ),
                              Text(type),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              addWordController
                                  .addWordToWordbank(
                                      wordbankId: widget.wordbankId)
                                  .then((_) {
                                // Refresh the word list after adding a word
                                wordsController.getWordsList();
                              });
                            },
                            child: const Text(
                              'Save and one more',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => WordsInUnitScreen(
                                  wordbankId: widget.wordbankId));
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Display words fetched from backend using WordsController
              Obx(() {
                if (wordsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (wordsController.wordList.isEmpty) {
                  return const Center(child: Text('No words available.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent scroll conflicts with SingleChildScrollView
                  itemCount: wordsController.wordList.length,
                  itemBuilder: (context, index) {
                    var word = wordsController.wordList[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            '${word["chinese_name"]} - ${word["english_name"]}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          // subtitle: Text(
                          //   'Type: ${word["type"] != null ? word["type"].join(", ") : "N/A"}',
                          //   style: const TextStyle(fontSize: 14),
                          // ),
                          // trailing: IconButton(
                          //   icon: const Icon(Icons.delete),
                          //   onPressed: () {
                          //     // Handle deletion logic if needed
                          //   },
                          // ),
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
