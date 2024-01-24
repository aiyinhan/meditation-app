import 'package:flutter/material.dart';
import 'package:meditation/game/sudoku/sudoku.dart';
import 'package:meditation/pages/mindGame.dart';

import '../game_level.dart';

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
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, mindGame.id);
                          },
                          icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                      SizedBox(width: 75 ,),
                      Text(
                        'How to Play?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 17,
                      right: 17,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      color: Colors.white54,
                    ),
                    child: Text(
                      'Welcome to Sudoku! Your goal is to fill a 9x9 grid with numbers from 1 to 9, use each number from 1 to 9 only once in each row, column, and 3x3 box. Enjoy playing Sudoku!',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blueAccent,
                      blurRadius: 10,
                      //offset: Offset.infinite,
                    ),
                  ],
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      30.0,
                    ),
                    topRight: Radius.circular(
                      30.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Choose the Level',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                  
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                  
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => sudoku(difficultyLevel: DifficultyLevel.easy,
                                    ),
                                  ));
                            },
                            child:gameLevel(Leveltext: 'Easy', colors: Colors.teal[300],)
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          sudoku(difficultyLevel: DifficultyLevel.medium,)));
                            },
                            child: gameLevel(Leveltext: 'Medium',colors: Colors.amber[300])
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                  sudoku(difficultyLevel: DifficultyLevel.hard,)));
                            },
                            child: gameLevel(Leveltext: 'Hard',colors: Colors.red[400])
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

