import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../view_model/controller/add_wordsbank_controller.dart';
import '../view_model/controller/notification_controller.dart';

class AddWordbankScreen extends StatelessWidget {
  final bool isRename;
  final int? id;
  final Map<String, dynamic>? wordBank; // Make wordBank optional for create

  const AddWordbankScreen(
      {super.key, this.isRename = false, this.id, this.wordBank});

  @override
  Widget build(BuildContext context) {
    final AddWordbankController controller = Get.put(AddWordbankController());
    final NotificationController notificationController =
        Get.put(NotificationController());
    // Clear the text controllers if this is not a rename operation (i.e., adding a new wordbank)
    if (!isRename) {
      controller.nameController.clear();
      controller.footnoteController.clear();
    } else if (isRename && wordBank != null) {
      // Pre-fill the name and footnote controllers if renaming and wordBank is not null
      controller.nameController.text = wordBank!['name'];
      controller.footnoteController.text =
          wordBank!['footnote'] ?? ''; // In case footnote is null
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(isRename ? 'rename_wordbank'.tr : 'add_wordbank'.tr),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Obx(
              () => Row(
                children: [
                  Icon(
                    Icons.create,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Text('${notificationController.totalCount.value}'),
                ],
              ),
            ),
          ),
          SizedBox(width: 15), // Add margin left
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
                Text(
                  'name'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.nameController,
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
                    hintText: 'enter_name'.tr,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[^ \-\.\s]')), // Allow all except space, dash, and dot
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'footnote'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.footnoteController,
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
                    hintText: 'footnote_hint'.tr, // Placeholder text
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[^ \-\.\s]')), // Allow all except space, dash, and dot
                  ],
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
                      // Call create or rename wordbank action and pass the ID if renaming
                      if (isRename && id != null) {
                        controller.renameWordbank(id: id!); // Pass the ID
                      } else {
                        controller.createWordbank();
                      }
                    },
                    child: Text(
                      isRename ? 'rename_wordbank'.tr : 'create_wordbank'.tr,
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
