import 'package:flutter/material.dart';
import 'package:meditation/components/game_list.dart';
import 'package:meditation/game/memorygame/home.dart';
import 'package:meditation/game/puzzlegame/screen/puzzleboard.dart';
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('images/alphabet.jpg',
                                height: 80,
                                width:90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Memory Matching Game",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Text('Welcome to Memory Matching Game! Flip cards to find matching pairs! Remember their positions and match them all to win! Test your memory skills and have fun!'),
                                    contentTextStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Alegreya',
                                    ),
                                    title: Center(
                                        child: Text('How To Play')
                                    ),
                                    titleTextStyle: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Alegreya',
                                    ),
                                    actions: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 40),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF8E97FD)),
                                            onPressed: (){
                                              Navigator.pushNamed(context, Home.id);
                                            },
                                            child: Text(
                                              'Start the Game',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Alegreya',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 25,
                              ),
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
                          child: gameList(image:'images/puzzle.jpg', name: 'Block Puzzle', icon: Icons.arrow_forward_ios),
                        onTap: (){
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: Text(
                                'Welcome to Block Puzzle Game! Arrange blocks to clear one row and score points. Can you clear rows and reach a high score? Have fun playing!',
                                textAlign: TextAlign.justify,
                              ),
                              contentTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                              title: Center(
                                  child: Text('How To Play')
                              ),
                              titleTextStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                              actions: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF8E97FD)),
                                      onPressed: (){
                                        Navigator.pushNamed(context, GameBoard.id);
                                      },
                                      child: Text(
                                        'Start the Game',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Alegreya',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                        },
                      ),
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
