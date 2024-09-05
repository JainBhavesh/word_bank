import 'package:flutter/material.dart';

class AddWordToWordbankScreen extends StatefulWidget {
  const AddWordToWordbankScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddWordToWordbankScreenState createState() =>
      _AddWordToWordbankScreenState();
}

class _AddWordToWordbankScreenState extends State<AddWordToWordbankScreen> {
  final List<String> words = [];
  final TextEditingController chineseController = TextEditingController();
  final TextEditingController englishController = TextEditingController();
  final List<String> wordTypes = ['noun', 'verb', 'prep', 'conj', 'adj', 'adv'];
  final Map<String, bool> selectedTypes = {
    'noun': true,
    'verb': true,
    'prep': true,
    'conj': true,
    'adj': true,
    'adv': true,
  };

  void saveWord() {
    setState(() {
      words.add(englishController.text);
      chineseController.clear();
      englishController.clear();
    });
  }

  void deleteWord(int index) {
    setState(() {
      words.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add words'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chinese',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: chineseController,
                          decoration: InputDecoration(
                            labelText: 'Value',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'English',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: englishController,
                          decoration: InputDecoration(
                            labelText: 'Value',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8.0,
                      children: wordTypes.map((type) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: selectedTypes[type],
                              onChanged: (value) {
                                setState(() {
                                  selectedTypes[type] = value!;
                                });
                              },
                            ),
                            Text(type),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(150, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: saveWord,
                          child: const Text(
                            'Save and one more',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(100, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            saveWord();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          words[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'delete') {
                              deleteWord(index);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ],
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
