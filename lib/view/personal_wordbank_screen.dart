import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';
import '../components/PersonalWordBankList.dart';
import '../view_model/controller/add_wordsbank_controller.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/wordsbank_controller.dart';

class PersonalWordbankScreen extends StatefulWidget {
  const PersonalWordbankScreen({super.key});

  @override
  State<PersonalWordbankScreen> createState() => _PersonalWordbankScreenState();
}

class _PersonalWordbankScreenState extends State<PersonalWordbankScreen> {
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
        title: Text('personal_wordbank'.tr),
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
        if (controller.personalwordBankList.isEmpty) {
          return Center(child: Text('no_word_bank_list'.tr));
        }

        // Display the word bank list when the data is available
        return ListView.builder(
          itemCount: controller.personalwordBankList.length,
          itemBuilder: (context, index) {
            var wordBank = controller.personalwordBankList[index];
            return ListItemWidget(
              index: index,
              wordBank: wordBank,
            );
          },
        );
      }),
      floatingActionButton: SizedBox(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(RouteName.addWordBankScreen);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
