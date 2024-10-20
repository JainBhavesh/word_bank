import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'settings'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'member'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars),
          label: 'achievement'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'about'.tr,
        ),
      ],
    );
  }
}
