import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/controller/settings_controller.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settings> {
  final SettingsController controller = Get.put(SettingsController());

  // English Levels and AI Styles
  final List<String> englishLevels = ['Starter', 'Medium', 'Advanced'];
  final List<String> aiStyles = ['Encouraging', 'Humor', 'Ironic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Observe and bind data from the controller
          var settings = controller.getSettingData;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings Title
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'settings'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              // Sound Effect Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sound Effect', style: TextStyle(fontSize: 18)),
                  Switch(
                    value: settings['sound_effect'] == 'on',
                    onChanged: (value) {
                      // Update getSettingData when switch is toggled
                      controller.getSettingData['sound_effect'] =
                          value ? 'on' : 'off';
                    },
                  ),
                ],
              ),

              // Background Music Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Background Music', style: TextStyle(fontSize: 18)),
                  Switch(
                    value: settings['music_effect'] == 'on',
                    onChanged: (value) {
                      // Update getSettingData when switch is toggled
                      controller.getSettingData['music_effect'] =
                          value ? 'on' : 'off';
                    },
                  ),
                ],
              ),
              SizedBox(height: 5),

              // English Level Checkbox List
              Text('My English Level', style: TextStyle(fontSize: 18)),
              ...englishLevels.map((level) {
                return CheckboxListTile(
                  title: Text(level),
                  value: settings['english_level']?.toLowerCase() ==
                      level.toLowerCase(),
                  onChanged: (bool? value) {
                    if (value == true) {
                      // Update getSettingData with selected English level
                      controller.getSettingData['english_level'] = level;
                    }
                  },
                );
              }).toList(),

              // AI Sentence Style Checkbox List
              Text('AI Sentence Style', style: TextStyle(fontSize: 18)),
              ...aiStyles.map((style) {
                return CheckboxListTile(
                  title: Text(style),
                  value: settings['ai_level']?.toLowerCase() ==
                      style.toLowerCase(),
                  onChanged: (bool? value) {
                    if (value == true) {
                      // Update getSettingData with selected AI style
                      controller.getSettingData['ai_level'] = style;
                    }
                  },
                );
              }).toList(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (() {
                    controller.updateSetting().then((_) {
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                        Get.back();
                      });
                    }); // Call API with updated data
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'submit'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
