import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';

import '../view/add_word_to_wordbank.dart';
import '../view/add_wordbank.dart';
import '../view_model/controller/add_wordsbank_controller.dart';

class ListItemWidget extends StatelessWidget {
  final int index;
  final Map<String, dynamic> wordBank; // Receive the entire wordBank object

  const ListItemWidget(
      {super.key, required this.index, required this.wordBank});

  @override
  Widget build(BuildContext context) {
    final AddWordbankController controller = Get.find<AddWordbankController>();
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
          title: Text(wordBank['name']), // Display the wordBank name
          subtitle: Text(
              wordBank['footnote'] != null && wordBank['footnote'].isNotEmpty
                  ? wordBank['footnote']
                  : ''), // Display additional info (like the ID)
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
                      // Pass the wordBank's id when renaming
                      Get.to(() => AddWordbankScreen(
                          isRename: true, id: wordBank['id']));
                      break;
                    case 'add':
                      Get.to(() =>
                          AddWordToWordbankScreen(wordbankId: wordBank['id']));
                      break;
                    case 'delete':
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this wordbank?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteWordbank(id: wordBank['id']);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
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
