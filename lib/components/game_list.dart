import 'package:flutter/material.dart';

class gameList extends StatelessWidget {
  const gameList({Key? key, required this.image, required this.name, required this.icon}) : super(key: key);
  final String image;
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(image,
              height: 80,
              width:90,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 20,),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Alegreya',
            ),
          ),
          Spacer(),
          Icon(
            icon,
            size: 25,
          ),
        ],
      ),
    );
  }
}

