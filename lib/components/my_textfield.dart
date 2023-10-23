import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obscureText;



  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Alegreya',
        ),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF8E97FD),
              width: 2.0,
            ),
          ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 23,
            ),
        ),
      ),
    );
  }
}
