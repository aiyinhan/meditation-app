import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 70),
      decoration: BoxDecoration(
        color:Color(0xFF8E97FD),
        borderRadius: BorderRadius.circular(10),
      ),
        child: Center(
          child: Text(
            'LOGIN',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily:'Alegreya' ),

          ),
        ),
      ),
    );
  }
}
