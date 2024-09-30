import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/builtin_wordbank_list.dart';
import '../view_model/controller/add_wordsbank_controller.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/wordsbank_controller.dart';

class BuiltInWordbankScreen extends StatefulWidget {
  const BuiltInWordbankScreen({super.key});

  @override
  State<BuiltInWordbankScreen> createState() => _BuiltInWordbankScreenState();
}

class _BuiltInWordbankScreenState extends State<BuiltInWordbankScreen> {
  final WordsbankController controller = Get.put(WordsbankController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    Get.put(AddWordbankController());
  }

  void fetchData() {
    notificationController.getNotificationCount();
    notificationController.getTodayTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            fetchData();
          },
        ),
        title: Text('built_in_wordbank'.tr),
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
          return Center(child: Text('no_word_bank_list.'.tr));
        }

        // Display the word bank list when the data is available
        return ListView.builder(
          itemCount: controller.buildinwordBankList.length,
          itemBuilder: (context, index) {
            var wordBank = controller.buildinwordBankList[index];
            return BuiltinWordbankList(
              index: index,
              wordBank: wordBank,
            );
          },
        );
      }),
    );
  }
}
