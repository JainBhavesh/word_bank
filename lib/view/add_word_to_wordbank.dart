import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/controller/add_Word_To_WordbankController.dart';

class AddWordToWordbankScreen extends StatefulWidget {
  final int wordbankId;

  const AddWordToWordbankScreen({super.key, required this.wordbankId});

  @override
  _AddWordToWordbankScreenState createState() =>
      _AddWordToWordbankScreenState();
}

class _AddWordToWordbankScreenState extends State<AddWordToWordbankScreen> {
  final AddWordToWordbankbankController controller =
      Get.put(AddWordToWordbankbankController());

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
        // Wrap the content in a scrollable view
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
                        controller: controller.chineseController,
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
                        controller: controller.englishController,
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
                        children: controller.wordTypes.map((type) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: controller.selectedTypes[type],
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedTypes[type] = value!;
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
                              controller.addWordToWordbank(
                                wordbankId: widget.wordbankId,
                              );
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
                              controller.addWordToWordbank(
                                wordbankId: widget.wordbankId,
                              );
                              Get.back(); // Navigate back after saving
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
              GetBuilder<AddWordToWordbankbankController>(
                builder: (controller) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent scroll conflicts with SingleChildScrollView
                    itemCount: controller.words.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              '${controller.words[index]["chinese_name"]} - ${controller.words[index]["english_name"]}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              'Type: ${controller.words[index]["type"].join(", ")}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                controller.deleteWordFromUI(index);
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
