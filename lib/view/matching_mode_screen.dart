import 'package:flutter/material.dart';
import 'package:word_bank/components/button_widget.dart';

class MatchingModeScreen extends StatefulWidget {
  const MatchingModeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MatchingModeScreenState createState() => _MatchingModeScreenState();
}

class _MatchingModeScreenState extends State<MatchingModeScreen> {
  final List<String> words = [
    'accord',
    'acceptable',
    'accident',
    'account',
    'accurate'
  ];
  final List<String> meanings = [
    '[n]一致、符合',
    '[a]可接受的, 合意的',
    '[n]意外事件,事故',
    '[n]計算,帳目',
    '[a]正確的,精確的'
  ];

  List<bool> selectedWords = [];
  List<bool> selectedMeanings = [];
  int? selectedWordIndex;
  int? selectedMeaningIndex;

  @override
  void initState() {
    super.initState();
    selectedWords = List<bool>.filled(words.length, false);
    selectedMeanings = List<bool>.filled(meanings.length, false);
  }

  void _onWordSelected(int index) {
    setState(() {
      if (selectedWordIndex != null) {
        selectedWords[selectedWordIndex!] = false;
      }
      selectedWordIndex = index;
      selectedWords[index] = true;
      _checkMatch();
    });
  }

  void _onMeaningSelected(int index) {
    setState(() {
      if (selectedMeaningIndex != null) {
        selectedMeanings[selectedMeaningIndex!] = false;
      }
      selectedMeaningIndex = index;
      selectedMeanings[index] = true;
      _checkMatch();
    });
  }

  void _checkMatch() {
    if (selectedWordIndex != null && selectedMeaningIndex != null) {
      if (selectedWordIndex == selectedMeaningIndex) {
        // Match found
        selectedWords[selectedWordIndex!] = false;
        selectedMeanings[selectedMeaningIndex!] = false;
        selectedWordIndex = null;
        selectedMeaningIndex = null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match Found!')),
        );
      } else {
        // No match
        selectedWords[selectedWordIndex!] = false;
        selectedMeanings[selectedMeaningIndex!] = false;
        selectedWordIndex = null;
        selectedMeaningIndex = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Mode'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // English words column
                  Expanded(
                    child: ListView.builder(
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedWords[index]
                                  ? Colors.grey
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _onWordSelected(index),
                            child: Text(words[index],
                                style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Chinese meanings column
                  Expanded(
                    child: ListView.builder(
                      itemCount: meanings.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedMeanings[index]
                                  ? Colors.grey
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _onMeaningSelected(index),
                            child: Text(meanings[index],
                                style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ButtonWidget(
                label: 'Quit test',
                icon: Icons.logout,
                textColor: Colors.white,
                onPressed: () {
                  print('Delete unit pressed');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
