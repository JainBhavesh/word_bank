import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final IconData? icon; // Optional icon
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    required this.label,
    this.icon, // Optional icon
    this.backgroundColor = Colors.black, // Default background color
    this.textColor = Colors.white, // Default text color
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) // Check if icon is provided
              Icon(
                icon,
                color: textColor,
              ),
            if (icon != null)
              const SizedBox(
                  width: 8), // Add spacing between icon and text if icon exists
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
