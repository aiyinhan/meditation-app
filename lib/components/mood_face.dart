import 'package:flutter/material.dart';

class moodFace extends StatelessWidget {
  final String emoji;
  final Color color;
  const moodFace({Key? key , required this.emoji, required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
              emoji,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
      );
  }
}
