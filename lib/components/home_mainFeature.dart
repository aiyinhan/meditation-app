import 'package:flutter/material.dart';

class mainFeatures extends StatelessWidget {
  final String image;
  final String name;
  final Color? color;
  const mainFeatures({Key? key , required this.image , required this.name, required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height:150,
      decoration:BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(image,
          width: 110,
          height: 110,),
          Text(
            name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
        ),
      ),
      ]
      ),
    );
  }
}
