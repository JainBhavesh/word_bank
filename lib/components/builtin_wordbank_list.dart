import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';

import '../view_model/controller/add_wordsbank_controller.dart';

class BuiltinWordbankList extends StatelessWidget {
  final int index;
  final Map<String, dynamic> wordBank; // Receive the entire wordBank object

  const BuiltinWordbankList(
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
            Get.toNamed(RouteName.unitSelector,
                arguments: {'id': wordBank['id']});
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
              if (wordBank['unit_count'] != null && wordBank['unit_count'] != 0)
                Badge(
                  value: wordBank['unit_count'].toString(),
                  color: Colors.red,
                ),
              const SizedBox(width: 8),
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
