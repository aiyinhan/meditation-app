import 'package:flutter/material.dart';

class gamebtn extends StatelessWidget {
  final String title;
  final Function() onTap;

  const gamebtn({Key? key,required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.indigo[50], shape: BoxShape.circle),
        child: Center(
          child: Text(title,style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}


