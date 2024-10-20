import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../view_model/controller/notification_controller.dart';
import '../view_model/controller/unit_selector_controller.dart';

class TargetDateScreen extends StatefulWidget {
  const TargetDateScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TargetDateScreenState createState() => _TargetDateScreenState();
}

class _TargetDateScreenState extends State<TargetDateScreen> {
  DateTime? selectedDate = DateTime.now();
  final UnitSelectorController unitSelectorController =
      Get.find<UnitSelectorController>();
  final NotificationController notificationController =
      Get.put(NotificationController());

  void _clearDate() {
    setState(() {
      selectedDate = null;
    });
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _confirm() async {
    if (selectedDate != null) {
      var unitId = Get.arguments['unitId'];
      var wordBankId = Get.arguments['wordBankId'];

      var formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

      await unitSelectorController.updateWordsUnit(unitId, formattedDate);

      if (!unitSelectorController.isLoading.value) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        Get.back();
        unitSelectorController.getWordsList(wordBankId);
        // Navigate back after the update
      }
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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Obx(
              () => Row(
                children: [
                  Icon(
                    Icons.create,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Text('${notificationController.totalCount.value}'),
                ],
              ),
            ),
          ),
          SizedBox(width: 15), // Add margin left
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'target_date'.tr,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                Text(
                  'target_date_message'.tr,
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
                      Text(
                        'select_date'.tr,
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
                            child: Text(
                              'clear'.tr,
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 16),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _cancel,
                                child: Text(
                                  'cancel'.tr,
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 16),
                                ),
                              ),
                              TextButton(
                                onPressed: _confirm,
                                child: Text(
                                  'ok'.tr,
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 16),
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
          Obx(() {
            return unitSelectorController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
