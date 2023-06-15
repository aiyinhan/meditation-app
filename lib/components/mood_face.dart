import 'package:flutter/material.dart';

class moodFace extends StatelessWidget {
  final String emoji;
  const moodFace({Key? key , required this.emoji}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
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
