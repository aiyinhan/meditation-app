import 'package:flutter/material.dart';
import 'package:meditation/game/game_list.dart';
import 'package:meditation/game/memorygame/home.dart';
import 'package:meditation/game/puzzlegame/screen/puzzleHome.dart';
import 'package:meditation/game/sudoku/sudokuLevelHome.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';

import '../game/mathGame/mathLevelHome.dart';



class mindGame extends StatefulWidget {
  const mindGame({Key? key}) : super(key: key);
  static String id = "mindGame";

  @override
  State<mindGame> createState() => _mindGameState();
}

class _mindGameState extends State<mindGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, homePage.id);
                  },
                  child: Icon(
                      Icons.home,color: Colors.grey[700],)),
              label: ''),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, reminderPage.id);
                  },
                  child: Icon(Icons.timer)),
              label: ''),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProfilePage.id);
                  },
                  child: Icon(Icons.person_2)),
              label: ''),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, homePage .id);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size:30
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text('Mind Games',
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Source Sans Pro',
                    ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      //simple maths
                      GestureDetector(
                          onTap: (){
                           Navigator.pushNamed(context, MathLevelPage.id);
                          },
                          child: gameList(image: 'images/math.png', name: 'Simple Mathematics', icon: Icons.arrow_forward_ios)
                      ),

                      //Memory Matching game
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            //simple maths
                            GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, Home.id);
                                },
                                child: gameList(image:'images/alphabet.png', name: 'Memory Matching ', icon: Icons.arrow_forward_ios)
                            ),
                          ],
                        ),
                      ),

                      //sudoku
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, sudokuLevelPage.id);
                          },
                          child: gameList(image: 'images/imagegame.png', name: 'Sudoku', icon: Icons.arrow_forward_ios)),


                      //tetirs
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, puzzleHome.id);
                          },
                          child: gameList(image: 'images/puzzle.jpg', name: 'Puzzle', icon: Icons.arrow_forward_ios)),


                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
