import 'package:flutter/material.dart';

class SudokuButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  const SudokuButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration:
            BoxDecoration(color: Colors.indigo[50]),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
