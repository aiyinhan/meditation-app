import 'package:flutter/material.dart';
import 'package:meditation/game/sudoku/sudoku.dart';
import 'package:meditation/pages/mindGame.dart';

class sudokuLevelPage extends StatefulWidget {
  const sudokuLevelPage({Key? key}) : super(key: key);
  static String id = 'sudokuLevel';
  @override
  State<sudokuLevelPage> createState() => _sudokuLevelPageState();
}

class _sudokuLevelPageState extends State<sudokuLevelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, mindGame.id);
                },
                icon: Icon(Icons.close)),
          ],
          backgroundColor: Color(0xFF8E97FD),
          title: Text(
            'Choose the Level',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Alegreya',
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sudoku(
                          difficultyLevel: DifficultyLevel.easy,
                        ),
                      ));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Color(0xFFCBCFFF), boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.white,
                      spreadRadius: 0.5,
                      //offset: Offset(3, 4)
                    )
                  ]),
                  child: Text(
                    'Easy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sudoku(
                          difficultyLevel: DifficultyLevel.medium,
                        ),
                      ));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Color(0xFFCBCFFF), boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.white,
                      spreadRadius: 0.5,
                      //offset: Offset(3, 4)
                    )
                  ]),
                  child: Text(
                    'Medium',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sudoku(
                          difficultyLevel: DifficultyLevel.hard,
                        ),
                      ));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Color(0xFFCBCFFF), boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.white,
                      spreadRadius: 0.5,
                      //offset: Offset(3, 4)
                    )
                  ]),
                  child: Text(
                    'Hard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
              ),
            ])));
  }
}
