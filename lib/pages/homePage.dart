import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/ProgressPage.dart';
import 'package:meditation/pages/breathingExercise.dart';
import 'package:meditation/pages/checkin.dart';
import 'package:meditation/pages/downloaded.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/pages/reminderPage.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);
  static String id = "homePage";

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8E97FD),
      bottomNavigationBar: BottomNavigationBar(items:[
        BottomNavigationBarItem(
            icon:
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, homePage.id);
              },
                child: Icon(Icons.home,color: Colors.grey[700],)),
            label: ''),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, reminderPage.id);
                },
                child: Icon(Icons.timer)), label: ''),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, ProfilePage.id);
              },
              child: Icon(Icons.person_2)), label: ''),
    ],
    ),
      body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Find Relaxation through Meditation.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.white,
                  endIndent: 20,
                  indent: 20,
                  thickness: 2,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //breathing exercise
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, breathingExercise.id);
                      },
                      child: Container(
                        width: 188,
                        height:75,
                        decoration:BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.person,
                            ),
                            Text(
                                'Breathing Exericse',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),

                    //music therapy
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, musicPage.id);
                      },
                      child: Container(
                        width: 188,
                        height:75,
                        decoration:BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.music_note,
                              ),
                              Text(
                                'Music Therapy',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                //Mind Game
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Mind Game
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, mindGame.id);
                      },
                      child: Container(
                        width: 188,
                        height:75,
                        decoration:BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.games,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  'Mind Game',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),

                    //mood checkin
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, CheckinPage.id);
                      },
                      child: Container(
                        width: 188,
                        height:75,
                        decoration:BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.mood,
                              ),
                              Text(
                                'Mood Check-in',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          //downloaded
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  Navigator.pushNamed(context, downloadMusic.id);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color:Color(0xFFDDE0FD),
                                  ),
                                  width: 280,
                                  height:60,
                                  child:const Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 40),
                                        child: Icon(
                                          Icons.file_download,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30,bottom:5),
                                        child: Text(
                                          'Downloaded',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:26),

                          //favourite
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:Color(0xFFDDE0FD),
                                ),
                                width: 280,
                                height:60,
                                child:const Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Icon(
                                        Icons.favorite,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 30,bottom:5),
                                      child: Text(
                                        'Favourite',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:26),

                          //progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  Navigator.pushNamed(context, ProgressPage.id);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color:Color(0xFFDDE0FD),
                                  ),
                                  width: 280,
                                  height:60,
                                  child: const Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 40),
                                        child: Icon(
                                          Icons.track_changes,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30,bottom:5),
                                        child: Text(
                                          'Progress',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
