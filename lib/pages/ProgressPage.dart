import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);
  static String id = "ProgressPage";

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, homePage.id);
                },
                child: Icon(Icons.home,color: Colors.grey[700],)
            ),
            label: ''
        ),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, reminderPage.id);
                },
                child: Icon(Icons.timer)
            ),
            label: ''
        ),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, ProfilePage.id);
                },
                child: Icon(Icons.person_2)
            ),
            label: ''
        ),
      ],),
      body: SafeArea(
        //background
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFF8E97FD),
                  Colors.white,
                ],
              ),
          ),
          child: Center(
            //music
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child:  Text(
                    'Music',
                    style: TextStyle(
                      fontSize: 33.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //music container
                Container(
                  width: 320,
                  height:150,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 55, top: 25, bottom: 30),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,),
                            Text(
                              'Mindful Minutes',
                              style: TextStyle(
                                fontFamily: 'Alegreya',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //update the duration of session
                      Text(
                        "50min",
                        style: TextStyle(
                          fontFamily: 'Alegreya',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                      ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40,),

                //exercise
                const Text(
                  'Breathing Exercise',
                  style: TextStyle(
                    fontSize: 33.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Alegreya',
                  ),
                ),

                SizedBox(height: 10),

                //breathing container
                Container(
                  width: 320,
                  height:250,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 55, top: 25, bottom: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,),
                            Text(
                              'Mindful Minutes',
                              style: TextStyle(
                                fontFamily: 'Alegreya',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "50min",
                        style: TextStyle(
                          fontFamily: 'Alegreya',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 20,),

                      Divider(
                        color: Colors.black,
                        endIndent: 30,
                        indent: 30,
                        thickness: 1.5,),

                      //total session
                      Padding(
                        padding: EdgeInsets.only(left: 70, top: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer),
                            Text(
                              'Total Session',
                              style: TextStyle(
                                fontFamily: 'Alegreya',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //update the duration of session
                      Text(
                        "1",
                        style: TextStyle(
                          fontFamily: 'Alegreya',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
