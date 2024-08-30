import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../routes/routes_name.dart';

class TargetDateScreen extends StatefulWidget {
  const TargetDateScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TargetDateScreenState createState() => _TargetDateScreenState();
}

class _TargetDateScreenState extends State<TargetDateScreen> {
  DateTime? selectedDate = DateTime.now();

  void _clearDate() {
    setState(() {
      selectedDate = null;
    });
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _confirm() {
    if (selectedDate != null) {
      print("Selected Date: ${DateFormat('EEE, MMM d').format(selectedDate!)}");
      Get.toNamed(RouteName.wordsInUnitScreen);
    }
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target date',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Do 8 tests before the target date.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '選擇日期',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('EEE, MMM d').format(selectedDate!)
                            : 'No date selected',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.edit, color: Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2101),
                    focusedDay: selectedDate ?? DateTime.now(),
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                      });
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    locale: 'en_US', // You can change this as needed
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _clearDate,
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.purple, fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _cancel,
                            child: const Text(
                              'Cancel',
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 16),
                            ),
                          ),
                          TextButton(
                            onPressed: _confirm,
                            child: const Text(
                              'OK',
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
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
