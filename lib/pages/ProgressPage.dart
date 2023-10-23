import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import '../music_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);
  static String id = "ProgressPage";

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _totalDurationInSeconds = 0; // Define it here
  int _totalCompletedSessions = 0;

  Future<int> _fetchMusicDuration() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await MusicService.fetchTotalMusicDuration(user.uid);
    }
    return 0;
  }

  void fetchBreathingExerciseData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('RegisterData')
          .doc(user.uid)
          .get();
      final docRef = FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('breathing_exercises')
          .doc('breathing_data');

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _totalDurationInSeconds = data['total_duration'] ?? 0;
          _totalCompletedSessions = data['total_completed_sessions'] ?? 0;
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    fetchBreathingExerciseData(); // Call the function to fetch data
  }
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
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: FutureBuilder<int>(
                    future: _fetchMusicDuration(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final musicDuration = snapshot.data ?? 0;
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 55, top: 25, bottom: 30),
                              child: Row(
                                children: [
                                  Icon(Icons.timer),
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
                              "$musicDuration min",
                              style: TextStyle(
                                fontFamily: 'Alegreya',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 40),

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
                  child: Column(
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
                        "$_totalDurationInSeconds seconds",
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
                        "$_totalCompletedSessions sessions",
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
