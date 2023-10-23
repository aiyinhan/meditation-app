
import 'package:flutter/material.dart';

class gameLevel extends StatelessWidget {
  final String Leveltext;
  final Color ?colors;
  const gameLevel({Key? key, required this.Leveltext, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Text(
        Leveltext,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 25,
            fontFamily: 'Alegreya',
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
