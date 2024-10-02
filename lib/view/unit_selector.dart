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

const double buttonSize = 90;

class _UnitSelectorState extends State<UnitSelector> {
  final UnitSelectorController unitSelectorController =
      Get.put(UnitSelectorController());

  int selectedUnitIndex = 0;
  final int totalUnits = 15;
  final int daysLeft = 22;
  late int unitId = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var id = Get.arguments['id'];
      unitId = id;
      unitSelectorController.getWordsList(id);
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   var id = Get.arguments['id'];
  //   unitSelectorController.getWordsList(id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_unit'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
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
                    return _buildDaysLeftButton(
                      typeData['id'] ??
                          0, // Provide a default value of 0 if 'id' is null
                      remainingDays, // Provide a default value of 0 if remainingDays is null
                      typeData['exam_count'] ?? 0,
                      unitId,
                      // Provide a default value of 0 if 'exam_count' is null
                    );
                  }
                });
      }),
    );
  }

  Widget _buildFinishButton() {
    return GestureDetector(
      onTap: () {
        // Get.offAllNamed(RouteName.homeScreen);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: CircularProgressIndicator(
              value:
                  1, // Since this is the finish button, we assume it's complete (1.0)
              strokeWidth: 10,
              color: Colors.red,
              backgroundColor: Colors.grey[300],
            ),
          ),
          Center(
            child: Text(
              'finish'.tr,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysLeftButton(
      int index, int daysLeft, int exam_count, int mainUnitId) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnitIndex = index;
        });
        Get.toNamed(RouteName.reviewOrTestScreen, arguments: {
          'unitId': index,
          'daysLeft': daysLeft,
          'mainUnitId': mainUnitId
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: buttonSize, // Adjusted size for progress indicator
            height: buttonSize,
            child: CircularProgressIndicator(
              value: exam_count / 8, // Dynamic value based on the exam_count
              strokeWidth: 10,
              color: Colors.red,
              backgroundColor: Colors.grey[300],
            ),
          ),
          Center(
            child: Text(
              '$daysLeft\n${'days_left'.tr}', // Using .tr for translations
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnplannedButton(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.targetDateScreen,
            arguments: {'unitId': index, "wordBankId": Get.arguments['id']});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: CircularProgressIndicator(
              value: 0, // Placeholder value (0.5), adjust based on your logic
              strokeWidth: 10,
              color: Colors.white,
              backgroundColor: Colors.grey[300],
            ),
          ),
          Center(
            child: Text(
              'unplanned'.tr,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
