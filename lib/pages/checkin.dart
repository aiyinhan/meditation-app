import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/components/mood_face.dart';
import 'package:meditation/components/mood_reason.dart';
import 'package:meditation/pages/MoodRecord.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({Key? key}) : super(key: key);
  static String id = "CheckinPage";

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  String selected = " ";
  Set<String> selectedReasons = {};
  String reason = " ";

  void _toggleMood(String reason) {
    setState(() {
      if (selectedReasons.contains(reason)) {
        selectedReasons.remove(reason);
      } else {
        selectedReasons.add(reason);
      }
    });
  }

  int _calculateWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return (days / 7).ceil();
  }

  Future<void> submitMoodRecord() async {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    final currentWeek = _calculateWeekNumber(now);
    final currentDay = now.day;
    print('currentDay:$currentDay');
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    final moodRecordRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('MoodRecord')
        .doc(currentYear.toString())
        .collection('Months')
        .doc(currentMonth.toString())
        .collection('Days')
        .doc(currentDay.toString());
    final existingRecordSnapshot = await moodRecordRef.get();
    if (existingRecordSnapshot.exists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Hi, mood record already exists for today.Please do it tomorrow :P',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Alegreya',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFF8E97FD),
                    fontFamily: 'Alegreya',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return; 
    } else {
      await moodRecordRef.set({
        "mood": selected,
        "reasons": selectedReasons.toList(),
        "date": now,
      });
      print('New mood record created successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBCFFF),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, homePage.id);
                  },
                  child: Icon(
                    Icons.home,
                    color: Colors.grey[700],
                  )),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  SizedBox(
                    height: 15,
                  ),
                  //3 difference faces
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //bad
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = '😊';
                              });
                            },
                            child: moodFace(
                              emoji: '😊',
                              color: selected == '😊'
                                  ? Colors.grey
                                  : Colors.white38,
                            ),
                          ),
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = '😐';
                              });
                            },
                            child: moodFace(
                              emoji: '😐',
                              color: selected == '😐'
                                  ? Colors.grey
                                  : Colors.white38,
                            ),
                          ),
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = '🙁';
                              });
                            },
                            child: moodFace(
                              emoji: '🙁',
                              color: selected == '🙁'
                                  ? Colors.grey
                                  : Colors.white38,
                            ),
                          ),
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
              SizedBox(height: 10),
              Divider(
                color: Colors.white,
                endIndent: 20,
                indent: 20,
                thickness: 2,
              ),
              SizedBox(height: 10),
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
                      Text(
                        'Can you tell me more?',
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
                                icon: Icons.family_restroom,
                                color: selectedReasons.contains('family')
                                    ? Colors.grey
                                    : Colors.transparent,
                                onTap: () => _toggleMood('family'),
                              ),
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
                                icon: Icons.health_and_safety,
                                color: selectedReasons.contains('health')
                                    ? Colors.grey
                                    : Colors.transparent,
                                onTap: () => _toggleMood('health'),
                              ),
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
                                icon: Icons.money,
                                color: selectedReasons.contains('money')
                                    ? Colors.grey
                                    : Colors.transparent,
                                onTap: () => _toggleMood('money'),
                              ),
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
                                icon: Icons.track_changes,
                                color: selectedReasons.contains('progress')
                                    ? Colors.grey
                                    : Colors.transparent,
                                onTap: () => _toggleMood('progress'),
                              ),
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
                                icon: Icons.people,
                                color: selectedReasons.contains('friend')
                                    ? Colors.grey
                                    : Colors.transparent,
                                onTap: () => _toggleMood('friend'),
                              ),
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
                                icon: Icons.shield_moon,
                                color: selectedReasons.contains('sleep')
                                    ? Colors.grey
                                    : Colors.transparent,
                                onTap: () => _toggleMood('sleep'),
                              ),
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
                    onPressed: () {
                      if (selected.isEmpty || selectedReasons.isEmpty) {
                        // Show error message
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Opps!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                              content: Text(
                                'Please select your mood and reason.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Color(0xFF8E97FD),
                                      fontFamily: 'Alegreya',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      } else {
                        submitMoodRecord();
                        Navigator.pushNamed(context, MoodRecord.id);
                      }
                    },
                    color: Color(0xFF8E97FD),
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
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
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
      ),
    );
  }
}
