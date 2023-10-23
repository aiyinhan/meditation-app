import 'package:flutter/material.dart';

class features extends StatelessWidget {
  final IconData icon;
  final String name;
  const features({Key? key , required this.icon,  required this.name}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFCBCFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: GestureDetector(
                //onTap: onTap(),
                child: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Alegreya',
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
