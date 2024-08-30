import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWordbankScreen extends StatelessWidget {
  final bool isRename;

  const AddWordbankScreen({super.key, this.isRename = false});

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
        title: Text(isRename ? 'Rename wordbank' : 'Add a wordbank'),
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
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    fillColor: Colors.grey[200], // Background color
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Footnote',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    fillColor: Colors.grey[100], // Background color
                    filled: true,
                    hintText: 'Enter footnote here...', // Placeholder text
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // make button full-width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle create or rename wordbank action
                      if (isRename) {
                        // Perform rename action
                        // Add actual rename logic here
                        Get.snackbar('Action', 'Wordbank renamed');
                      } else {
                        // Perform create action
                        // Add actual create logic here
                        Get.snackbar('Action', 'Wordbank created');
                      }
                    },
                    child: Text(
                      isRename ? 'Rename wordbank' : 'Create wordbank',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
