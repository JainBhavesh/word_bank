import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/showConfirmationPopup.dart';
import 'package:word_bank/routes/routes_name.dart';
import 'package:word_bank/view/add_word_to_wordbank.dart';

import '../view/add_wordbank.dart';

class ListItemWidget extends StatelessWidget {
  final int index;

  const ListItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          onTap: () {
            Get.toNamed(RouteName.unitSelector, arguments: {'index': index});
          },
          leading: const CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(
              'A',
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: const Text('List item'),
          subtitle: const Text('Supporting line text lorem ipsum...'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Badge(
                value: '4',
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (String value) {
                  switch (value) {
                    case 'rename':
                      // Pass the 'isRename' parameter to the next screen
                      Get.to(() => const AddWordbankScreen(isRename: true));
                      break;
                    case 'add':
                      // Handle add a word to wordbank action
                      // Get.snackbar('Action', 'Add a word to wordbank pressed');
                      Get.to(() => const AddWordToWordbankScreen());

                      break;
                    case 'delete':
                      // Show confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (context) => ShowConfirmationPopup(
                          title: "Quit test?",
                          message: "這次的作答記錄和積分都會取消，確定要離開測驗？",
                          confirmButtonText: "Confirm & quit",
                          cancelButtonText: "Cancel",
                          confirmIcon: Icons.exit_to_app,
                          onConfirm: () {
                            Navigator.of(context).pop();
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'rename',
                    child: Text('Rename'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'add',
                    child: Text('Add a Word to Wordbank'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete Wordbank'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this wordbank?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Handle the delete action here
                Get.snackbar('Action', 'Wordbank deleted');
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class Badge extends StatelessWidget {
  final String value;
  final Color color;

  const Badge({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        value,
        style: const TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}
