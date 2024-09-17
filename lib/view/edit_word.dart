import 'package:flutter/material.dart';
import 'package:word_bank/components/button_widget.dart';

class EditWordScreen extends StatefulWidget {
  final String? chineseWord;
  final String? englishWord;
  final Set<String>? selectedCategories;

  const EditWordScreen({
    super.key,
    this.chineseWord,
    this.englishWord,
    this.selectedCategories,
  });

  @override
  _EditWordScreenState createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  late TextEditingController _chineseController;
  late TextEditingController _englishController;
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _chineseController = TextEditingController(text: widget.chineseWord ?? '');
    _englishController = TextEditingController(text: widget.englishWord ?? '');
    _selectedCategories = widget.selectedCategories ?? {};
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  void dispose() {
    _chineseController.dispose();
    _englishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit word'),
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
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notice:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test record in this unit will be erased after editing a word.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Chinese', _chineseController),
            const SizedBox(height: 20),
            _buildTextField('English', _englishController),
            const SizedBox(height: 20),
            _buildCategoryCheckboxes(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonWidget(
                label: 'Done',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            fillColor: Colors.grey[200], // Background color
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCheckboxes() {
    const categories = ['noun', 'verb', 'prep', 'conj', 'adj', 'adv'];
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: categories.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _selectedCategories.contains(category),
              onChanged: (bool? value) {
                _toggleCategory(category);
              },
            ),
            Text(category),
          ],
        );
      }).toList(),
    );
  }
}
