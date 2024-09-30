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
        title: Text('add_words'.tr),
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
                      Text(
                        'chinese'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: addWordController.chineseController,
                        decoration: InputDecoration(
                          labelText: 'value'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'english'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: addWordController.englishController,
                        decoration: InputDecoration(
                          labelText: 'value'.tr,
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
                          return Obx(() {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value:
                                      addWordController.selectedTypes[type] ??
                                          false,
                                  onChanged: (value) {
                                    addWordController.selectedTypes[type] =
                                        value!;
                                  },
                                ),
                                Text(type),
                              ],
                            );
                          });
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              addWordController.updateBankId == 0
                                  ? addWordController
                                      .addWordToWordbank(
                                          wordbankId: widget.wordbankId)
                                      .then((_) {
                                      // Refresh the word list after adding a word
                                      wordsController.getWordsList();
                                    })
                                  : addWordController
                                      .editWordToWordbank()
                                      .then((_) {
                                      // Refresh the word list after adding a word
                                      wordsController.getWordsList();
                                      addWordController.chineseController
                                          .clear();
                                      addWordController.englishController
                                          .clear();
                                      addWordController.selectedTypes
                                          .updateAll((key, value) => false);
                                    });
                            },
                            child: Text(
                              'save_and_more'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Obx(() {
                            if (wordsController.wordListObj["units_count"] !=
                                    null &&
                                wordsController.wordListObj["units_count"] ==
                                    1) {
                              return Container(); // Return an empty container when units_count is 1
                            } else {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  minimumSize: const Size(100, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (wordsController.wordList.length >= 6) {
                                    Get.to(() => WordsInUnitScreen(
                                        wordbankId: widget.wordbankId));
                                  } else {
                                    Get.snackbar('Error', 'add_word_message'.tr,
                                        snackPosition: SnackPosition.TOP);
                                  }
                                },
                                child: Text(
                                  'done'.tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          })
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
                  return Center(child: Text('no_words_available'.tr));
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
                          trailing: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;

                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                    overlay.size.width,
                                    overlay.size.height / 2,
                                    0,
                                    0),
                                items: [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: const Icon(Icons.edit,
                                          color: Colors.black),
                                      title: Text('edit_word'.tr),
                                      onTap: () {
                                        // Set the controllers with the current word details for editing
                                        addWordController.updateBankId = 0;
                                        addWordController.chineseController
                                            .text = word["chinese_name"];
                                        addWordController.englishController
                                            .text = word["english_name"];

                                        // Set the checkboxes based on the types of the current word
                                        addWordController.setDataToUpdate(
                                          id: word['id'],
                                          chineseName: word['chinese_name'],
                                          englishName: word['english_name'],
                                          wordTypesToEdit: List<String>.from(word[
                                              'type']), // Pass the word types
                                        );

                                        // Close the menu
                                        Navigator.pop(context);
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      title: Text('delete_word'.tr,
                                          style: TextStyle(color: Colors.red)),
                                      onTap: () {
                                        // Call the delete function
                                        Navigator.pop(context);

                                        addWordController.deletWordToWordbank(
                                            id: word['id']);

                                        // Close the menu
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
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
