import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuiltInWordbankScreen extends StatefulWidget {
  const BuiltInWordbankScreen({super.key});

  @override
  State<BuiltInWordbankScreen> createState() => _BuiltInWordbankScreenState();
}

class _BuiltInWordbankScreenState extends State<BuiltInWordbankScreen> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.separated(
          itemCount: 10, // Replace with your dynamic item count
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: Colors.grey), // Separator line
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('List item $index'),
                subtitle: const Text('Supporting line text lorem ipsum...'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        // Handle more options
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
