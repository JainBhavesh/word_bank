import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_bank/components/button_widget.dart';
import 'package:word_bank/routes/routes_name.dart';

class PushTestScreen extends StatelessWidget {
  const PushTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push test'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Check words',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    // Add your function here
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 22 / 30, // Adjust this value as needed
                      strokeWidth: 15,
                      color: Colors.red,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const Text(
                    '22\nDays left',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ignore: prefer_const_constructors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ModeWidget(label: 'Easy mode', count: 3, color: Colors.yellow),
                ModeWidget(label: 'Adv mode', count: 2, color: Colors.orange),
                ModeWidget(label: 'Matching mord', count: 0, color: Colors.red),
                ModeWidget(label: 'Push test', count: 1, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ButtonWidget(
                label: 'Test',
                onPressed: () {
                  Get.toNamed(RouteName.matchingModeScreen);
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'What is push test?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To strengthen the memory of these words,\n'
              'you are asked to finish 7 push tests even this\n'
              'unit is finished.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModeWidget extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const ModeWidget({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
