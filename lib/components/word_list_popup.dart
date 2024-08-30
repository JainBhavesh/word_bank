import 'package:flutter/material.dart';
import 'package:word_bank/view/edit_word.dart';

class WordListPopup extends StatelessWidget {
  final List<String> words;

  const WordListPopup({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Word list',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: words.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(words[index]),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (String value) {
                      if (value == 'edit') {
                        _navigateToEditWordScreen(context, words[index]);
                      } else if (value == 'delete') {
                        // Handle delete word
                        print('Delete word: ${words[index]}');
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit word'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            'Delete word',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle list item tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditWordScreen(BuildContext context, String word) {
    // Example data for Chinese and English words and categories.
    String chineseWord = '额外'; // Placeholder; replace with real data
    String englishWord = word;
    Set<String> selectedCategories = {
      'noun',
      'verb'
    }; // Placeholder; replace with real data

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditWordScreen(
          chineseWord: chineseWord,
          englishWord: englishWord,
          selectedCategories: selectedCategories,
        ),
      ),
    );
  }
}
