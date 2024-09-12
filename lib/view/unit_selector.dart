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
        title: const Text('Choose a unit'),
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

                  if (targetDate == null) {
                    return _buildUnplannedButton();
                  } else if (targetDate.isBefore(DateTime.now())) {
                    return _buildFinishButton();
                  } else {
                    return _buildDaysLeftButton(index);
                  }
                },
              );
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
        child: const Center(
          child: Text(
            'Finish',
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

  Widget _buildDaysLeftButton(int index) {
    return GestureDetector(
      onTap: () {
        // Handle days left button tap
        setState(() {
          selectedUnitIndex = index;
        });
        Get.toNamed(RouteName.reviewOrTestScreen);
        print('Unit $index selected');
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
              color: selectedUnitIndex == index ? Colors.blue : Colors.red,
              width: 4),
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
              const Text(
                'Days left',
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

  Widget _buildUnplannedButton() {
    return GestureDetector(
      onTap: () {
        // Handle unplanned button tap (if necessary)
        print('Unplanned button pressed');
        Get.toNamed(RouteName.targetDateScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          border: Border.all(color: Colors.grey.shade400, width: 4),
        ),
        child: const Center(
          child: Text(
            'unplanned',
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
