import 'package:flutter/material.dart';

class TaskCircle extends StatelessWidget {
  final int daysLeft;
  final bool isFinish;

  const TaskCircle({super.key, required this.daysLeft, this.isFinish = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFinish ? Colors.yellow : Colors.red,
      ),
      child: Center(
        child: isFinish
            ? const Text(
                'Finish',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$daysLeft',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Days left',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
