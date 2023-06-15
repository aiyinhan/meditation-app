import 'package:flutter/material.dart';

class MoodReason extends StatelessWidget {
  const MoodReason({Key? key, required this.icon}) : super(key: key);
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

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
    );
  }
}
