import 'package:flutter/material.dart';

class MoodReason extends StatelessWidget {
  MoodReason({Key? key, required this.icon, required this.onTap, required this.color,  this.isSelected=false}) : super(key: key);
  final IconData? icon;
  final VoidCallback onTap;
  final Color color;
  final bool isSelected;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Icon(
              icon,
              color: Colors.black,
            ),
            ),
          ),
      ),
    );
  }
}
