import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/PersonalWordBankList.dart';
import '../view_model/controller/add_wordsbank_controller.dart';
import '../view_model/controller/wordsbank_controller.dart';

class BuiltInWordbankScreen extends StatefulWidget {
  const BuiltInWordbankScreen({super.key});

  @override
  State<BuiltInWordbankScreen> createState() => _BuiltInWordbankScreenState();
}

class _BuiltInWordbankScreenState extends State<BuiltInWordbankScreen> {
  final WordsbankController controller = Get.put(WordsbankController());

  @override
  void initState() {
    super.initState();
    Get.put(AddWordbankController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Built-in wordbanks'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.create),
                SizedBox(width: 5),
                Text('38812'),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Display a loader when data is being fetched
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Display a message if the word bank list is empty
        if (controller.buildinwordBankList.isEmpty) {
          return const Center(child: Text('No wordbanks available.'));
        }

        // Display the word bank list when the data is available
        return ListView.builder(
          itemCount: controller.buildinwordBankList.length,
          itemBuilder: (context, index) {
            var wordBank = controller.buildinwordBankList[index];
            return ListItemWidget(
              index: index,
              wordBank: wordBank,
            );
          },
        );
      }),
    );
  }
}
