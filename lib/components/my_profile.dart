import 'package:flutter/material.dart';

class myProfile extends StatelessWidget {
  final controller;
  final String name;
  final IconData? icon;

  const myProfile(
      {Key? key, required this.controller, required this.name, required this.icon})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        //enabled: isEditing,
        controller: controller,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          fontFamily: 'Alegreya',
        ),
        decoration: InputDecoration(
          label: Text(name),
          prefixIcon: Icon(icon),
          contentPadding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                25.0,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Color(0xFF8E97FD), width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(
                25.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
