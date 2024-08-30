import 'package:flutter/material.dart';
import 'package:word_bank/components/button_widget.dart';

class WordsInUnitScreen extends StatefulWidget {
  const WordsInUnitScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WordsInUnitScreenState createState() => _WordsInUnitScreenState();
}

class _WordsInUnitScreenState extends State<WordsInUnitScreen> {
  int _selectedWordCount = 6;
  final int _minWordCount = 6;
  final int _maxWordCount = 12;

  final List<String> words = [
    "accord",
    "acceptable",
    "accident",
    "account",
    "accurate",
    "ache",
    "achieve",
    "activity",
  ];

  void _incrementWordCount() {
    if (_selectedWordCount < _maxWordCount) {
      setState(() {
        _selectedWordCount++;
      });
    }
  }

  void _decrementWordCount() {
    if (_selectedWordCount > _minWordCount) {
      setState(() {
        _selectedWordCount--;
      });
    }
  }

  void _confirmSelection() {
    // Add your confirmation logic here
    Navigator.of(context).pop();
    print("Selected $_selectedWordCount words");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '38812',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'How many words in each unit',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, size: 30),
                  onPressed: _decrementWordCount,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_selectedWordCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right, size: 30),
                  onPressed: _incrementWordCount,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'You can select between 6 and 12.\n'
              'For difficult words, you might want to choose fewer words. You '
              'can’t change after clicking on “Confirm”',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ButtonWidget(
                label: 'Confirm',
                icon: Icons.logout,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: _confirmSelection,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      words[index],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
