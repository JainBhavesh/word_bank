import 'package:flutter/material.dart';
import 'package:word_bank/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:word_bank/view_model/controller/unit_selector_controller.dart';

class UnitSelector extends StatefulWidget {
  const UnitSelector({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UnitSelectorState createState() => _UnitSelectorState();
}

class _UnitSelectorState extends State<UnitSelector> {
  final UnitSelectorController unitSelectorController =
      Get.put(UnitSelectorController());

  int selectedUnitIndex = 0;
  final int totalUnits = 15;
  final int daysLeft = 22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_unit'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Handle back button press
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('38812')),
          ),
        ],
      ),
      body: Obx(() {
        if (unitSelectorController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return unitSelectorController.dateList.isEmpty
            ? const Center(child: Text('No data available'))
            : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: unitSelectorController.dateList.length,
                itemBuilder: (context, index) {
                  var typeData = unitSelectorController.dateList[index];
                  DateTime? targetDate =
                      unitSelectorController.parseDate(typeData['target_date']);

                  // Ensure remaining_days is an integer or 0 if not an int
                  int remainingDays = (typeData['remaining_day'] is int)
                      ? typeData['remaining_day']
                      : (typeData['remaining_day'] is String &&
                              typeData['remaining_day'] == "finish")
                          ? 0 // Handle case for "finish"
                          : 0; // Default to 0 for other cases

                  if (targetDate == null) {
                    return _buildUnplannedButton(typeData['id']);
                  } else if (typeData['remaining_day'] == "finish") {
                    return _buildFinishButton(); // Call your finish button function here
                  } else {
                    return _buildDaysLeftButton(typeData['id'], remainingDays);
                  }
                });
      }),
    );
  }

  Widget _buildFinishButton() {
    return GestureDetector(
      onTap: () {
        // Handle finish button tap
        print('Finish button pressed');
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow,
          border: Border.all(color: Colors.red, width: 4),
        ),
        child: Center(
          child: Text(
            'finish'.tr,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysLeftButton(int index, int daysLeft) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnitIndex = index;
        });
        Get.toNamed(RouteName.reviewOrTestScreen,
            arguments: {'unitId': index, 'daysLeft': daysLeft});
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: selectedUnitIndex == index ? Colors.blue : Colors.red,
            width: 4,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$daysLeft',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                'days_left'.tr,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnplannedButton(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.targetDateScreen, arguments: {'unitId': index});
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          border: Border.all(color: Colors.grey.shade400, width: 4),
        ),
        child: Center(
          child: Text(
            'unplanned'.tr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
