import 'package:flutter/material.dart';
import 'package:meditation/components/mood_face.dart';
import 'package:meditation/components/mood_reason.dart';
import 'package:meditation/pages/MoodRecord.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/pages/MoodRecord.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({Key? key}) : super(key: key);
  static String id = "CheckinPage";

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8E97FD),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, homePage.id);
                  },
                  child: Icon(Icons.home,color: Colors.grey[700],)),
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
      body: SafeArea(
        child: Column(
          children:  [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Mood Check-in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Alegreya',
                ),
              ),
            ),
            Column(
              children: [
                //how do you feel
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'How do you feel?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
                SizedBox(height: 15,),

                //3 difference faces
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //bad
                    Column(
                      children: [
                        moodFace(emoji: '😊'),
                        Text(
                          'Good',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                      ],
                    ),

                    //fine
                    Column(
                      children: [
                        moodFace(emoji: '😐'),
                        Text(
                          'Fine',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                      ],
                    ),

                    //well
                    Column(
                      children: [
                        moodFace(emoji: '🙁'),
                        Text(
                          'Bad',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height:10),
            Divider(
              color: Colors.white,
              endIndent: 20,
              indent: 20,
              thickness: 2,
            ),
            SizedBox(height:10),
            Container(
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text('Can you tell me more?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alegreya',
                      ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //family
                        Column(
                          children: [
                            MoodReason(
                                icon:Icons.family_restroom),
                            Text(
                              'Family',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                          ],
                        ),
                        //health
                        Column(
                          children: [
                            MoodReason(
                                icon:Icons.health_and_safety),
                            Text(
                              'Health',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                          ],
                        ),

                        //finance
                        Column(
                          children: [
                            MoodReason(
                                icon:Icons.money),
                            Text(
                              'Finance',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Progress
                        Column(
                          children: [
                            MoodReason(
                                icon:Icons.track_changes),
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                          ],
                        ),

                        //friend
                        Column(
                          children: [
                            MoodReason(
                                icon:Icons.people),
                            Text(
                              'Friend',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                          ],
                        ),

                        //Sleep
                        Column(
                          children: [
                            MoodReason(
                                icon:Icons.shield_moon),
                            Text(
                              'Sleep',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: SizedBox(
                height: 60,
                width: 300,
                child: MaterialButton(
                  padding: EdgeInsets.all(15),
                  onPressed: ()  {
                    Navigator.pushNamed(context, homePage.id);
                  },
                  color: Colors.black38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Alegreya',
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                Navigator.pushNamed(context, MoodRecord.id);
              },
              child: Text(
                'Go to Mood Record',
                style: TextStyle(
                  fontFamily: 'Alegreya',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

          ],
        ),


      ),
    );
  }
}
