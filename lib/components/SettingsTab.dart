import 'package:flutter/material.dart';
import 'SettingsRow.dart';

class SettingsScreen extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onClose;

  const SettingsScreen(
      {super.key, required this.scrollController, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SettingsRow(
                    title: 'Title',
                    detail: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Detail'),
                        Row(
                          children: [
                            Container(
                                width: 24, height: 24, color: Colors.grey),
                            const SizedBox(width: 4),
                            Container(
                                width: 24, height: 24, color: Colors.orange),
                            const SizedBox(width: 4),
                            Container(width: 24, height: 24, color: Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SettingsRow(title: 'Title', detail: Text('Detail')),
                  const SettingsRow(title: 'Title', detail: Text('Detail')),
                  const SettingsRow(title: 'Title', detail: Text('Detail')),
                  SettingsRow(
                    title: 'Title',
                    detail: Switch(value: true, onChanged: (value) {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
