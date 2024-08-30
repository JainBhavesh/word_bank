import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';
import '../components/PersonalWordBankList.dart';

class PersonalWordbankScreen extends StatelessWidget {
  const PersonalWordbankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Handle back button
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
      body: ListView.builder(
        itemCount: 10, // Replace with your dynamic item count

        itemBuilder: (context, index) {
          return ListItemWidget(
              index: index); // Use the ListItemWidget with index
        },
      ),
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
