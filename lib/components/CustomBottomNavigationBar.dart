import 'package:flutter/material.dart';

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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'member',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars),
          label: 'points',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'about',
        ),
      ],
    );
  }
}
