import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation/game/mathGame/gamebtn.dart';
import 'package:meditation/pages/mindGame.dart';

enum MathLevel{
  easy,
  medium,
  hard
}

class Math extends StatefulWidget {
  final MathLevel difficultyLevel;
  static String id = "Math";

  Math({
    required this.difficultyLevel,
  });
  @override
  State<Math> createState() => _MathState();
}

class _MathState extends State<Math> {
  int x = 0;
  int y =0;
  String operationSymbol =' ';
  String ans ='?';
  int z=0;
  late MathLevel difficultyLevel;

  void randomNum(MathLevel difficultyLevel) {
    setState(() {
      var rnd = Random();

      switch (difficultyLevel) {
        case MathLevel.easy:
          x = rnd.nextInt(10) + 1; // Adjust the range as needed for easy difficulty
          y = rnd.nextInt(10) + 1;
          if(x<y){
            int temp=x;
            x=y;
            y=temp;
          }
          break;
        case MathLevel.medium:
          x = rnd.nextInt(15) + 1; // Adjust the range as needed for medium difficulty
          y = rnd.nextInt(15) + 1;
          if(x<y){
            int temp=x;
            x=y;
            y=temp;
          }
          break;
        case MathLevel.hard:
          x = rnd.nextInt(20) + 1; // Adjust the range as needed for hard difficulty
          y = rnd.nextInt(15) + 1;
          if(x<y){
            int temp=x;
            x=y;
            y=temp;
          }
          break;
      }

      // Generate a random operation (addition, subtraction, or multiplication)
      int operation = rnd.nextInt(3); // 0: addition, 1: subtraction, 2: multiplication

      switch (operation) {
        case 0:
          z = x + y; // Addition
          operationSymbol = '+';
          break;
        case 1:
          z = x - y; // Subtraction
          operationSymbol = '-';
          break;
        case 2:
          z = x * y; // Multiplication
          operationSymbol = 'x';
          break;
      }
    });
  }

  //ques
  ShowQues(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$x $operationSymbol $y',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  //ans box
  showAnsBox(){
    Color? backgroundColor;
    if (ans=='?') {
      backgroundColor = Colors.indigo[50];
    } else if (ans=='$z') {
      backgroundColor = Colors.green;
    } else if (ans != '$z'){
      backgroundColor = Colors.red;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: Text(ans, style: TextStyle(fontSize: 30),)),
        ),
      ],
    );
  }

  //update ans
  updateAns(String lable){
    if (ans =='?'){
      ans='';
    }
    setState(() {
      ans+=lable;
      if(int.parse(ans)==z){
        print("Right Ans");

      }
    });
  }

  //refresh question
  newQues(){
    setState(() {
      ans='?';
    });
    randomNum(difficultyLevel);
  }

  //button option
  List <String> ansButton = ['1','2','3','4','5','6','7','8','9','0', 'DLT', 'Next'];

  @override
  void initState() {
    difficultyLevel =widget.difficultyLevel;
    super.initState();
    randomNum(difficultyLevel);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions:<Widget> [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, mindGame.id);
              }, icon:Icon(Icons.close)),
        ],
        backgroundColor: Color(0xFF8E97FD),
        title: Text('Math Game',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Alegreya',
        ),
        ),
      ),
      body: Column(
        children: [
          //questions
          SizedBox(
            height: 20,
          ),
          ShowQues(),
          SizedBox(
            height: 20,
          ),
          showAnsBox(),
          SizedBox(height: 20,),
          //button
          Expanded(
              child:GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: ansButton.map((e) => gamebtn(
                    title: e,
                    onTap: (){
                      if(e =='DLT'){
                        setState(() {
                          ans='?';
                        });
                        return;
                      }if(e =='Next') {
                        newQues();
                        return;
                      }
                      updateAns(e);
                      },
                    )).toList(),
              ),
          ),
        ],
      ),
    );
  }
}

