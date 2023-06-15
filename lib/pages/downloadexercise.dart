import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/downloaded.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';

class downloadExercise extends StatefulWidget {
  const downloadExercise({Key? key}) : super(key: key);
  static String id = "downloadExercise";

  @override
  State<downloadExercise> createState() => _downloadExerciseState();
}

class _downloadExerciseState extends State<downloadExercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        backgroundColor: Color(0xFF8E97FD),
        toolbarHeight: 80,
        title: Text('Downloaded'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'Alegreya',
        ),
      ),
      body: Row(
        children: [
          GestureDetector(
            onTap:(){
              Navigator.pushNamed(context, downloadMusic.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20,left: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Color(0xFFD9D9D9),
                ),
                width: 150,
                height:50,
                child:Padding(
                  padding: EdgeInsets.only(top:10,left: 40),
                  child: Text(
                    'Music',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap:(){
              Navigator.pushNamed(context, downloadExercise.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20,left: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Color(0xFFD9D9D9),
                ),
                width: 150,
                height:50,
                child:Padding(
                  padding: EdgeInsets.only(top:10,left: 40),
                  child: Text(
                    'Exercise',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
