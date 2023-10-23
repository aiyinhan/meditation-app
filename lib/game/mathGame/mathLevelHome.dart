import 'package:flutter/material.dart';
import 'package:meditation/components/game_level.dart';
import 'package:meditation/game/mathGame/mathGame.dart';
import 'package:meditation/pages/mindGame.dart';

class MathLevelPage extends StatefulWidget {
  static String id = "Math Level";
  const MathLevelPage({Key? key}) : super(key: key);

  @override
  State<MathLevelPage> createState() => _MathLevelPageState();
}

class _MathLevelPageState extends State<MathLevelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
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
                      'Welcome to Simple Mathematics! Sum up the numbers and click "NEXT" to answer the next question. If your answer is correct, the answer box will turn green. Otherwise, it will turn red. ',
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
                                builder: (context) => Math(
                                  difficultyLevel: MathLevel.easy,
                                ),
                              ));
                        },
                        child:gameLevel(Leveltext: 'Easy', colors: Colors.teal[400],)
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
                                      Math(difficultyLevel: MathLevel.medium)));
                        },
                        child: gameLevel(Leveltext: 'Medium',colors: Colors.orangeAccent)
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
                                      Math(difficultyLevel: MathLevel.hard)));
                        },
                        child: gameLevel(Leveltext: 'Hard',colors: Colors.redAccent)
                      ),
                    ],
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