import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';
import '../components/PersonalWordBankList.dart';
import '../view_model/controller/add_wordsbank_controller.dart';
import '../view_model/controller/wordsbank_controller.dart';

class PersonalWordbankScreen extends StatefulWidget {
  const PersonalWordbankScreen({super.key});

  @override
  State<PersonalWordbankScreen> createState() => _PersonalWordbankScreenState();
}

class _PersonalWordbankScreenState extends State<PersonalWordbankScreen> {
  // Initialize the WordsbankController
  final WordsbankController controller = Get.put(WordsbankController());

  @override
  void initState() {
    super.initState();
    // Initialize AddWordbankController here
    Get.put(
        AddWordbankController()); // This ensures the controller is available globally
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
        title: const Text('Personal wordbanks'),
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
        if (controller.wordBankList.isEmpty) {
          return const Center(child: Text('No wordbanks available.'));
        } else {
          return ListView.builder(
            itemCount: controller.wordBankList.length,
            itemBuilder: (context, index) {
              var wordBank = controller.wordBankList[index];
              return ListItemWidget(
                index: index,
                wordBank: wordBank,
              );
            },
          );
        }
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
