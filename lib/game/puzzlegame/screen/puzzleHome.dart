import 'package:flutter/material.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:meditation/game/puzzlegame/screen/puzzleboard.dart';

class puzzleHome extends StatefulWidget {
  const puzzleHome({Key? key}) : super(key: key);
  static String id = 'puzzlehome';
  @override
  State<puzzleHome> createState() => _puzzleHomeState();
}

class _puzzleHomeState extends State<puzzleHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: SingleChildScrollView(
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
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 75,
                        ),
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
                    SizedBox(
                      height: 25,
                    ),
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
                        'Welcome to Block Puzzle! Your job is to put colorful blocks in the right way on the board.  Move the puzzle on the board anywhere you like using left and right arrow, change the shape of puzzle using the change button in the middle of left and right arrow. Make sure the blocks form a complete row from left to right. When a row is filled up,it will disappear, and you will earn point.',
                        style: TextStyle(
                          height: 1.4,
                          letterSpacing: 0.2,
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, GameBoard.id);
                    },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        //width:double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Start Game',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
