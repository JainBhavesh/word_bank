import 'package:flutter/material.dart';

class EasyStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const EasyStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: size.width * 0.05,
            height: size.width * 0.05,
            decoration: BoxDecoration(
              color: index <= currentStep ? Colors.red : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
