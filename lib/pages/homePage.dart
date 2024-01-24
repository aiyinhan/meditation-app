import 'package:flutter/material.dart';
import 'package:meditation/components/home_mainFeature.dart';
import 'package:meditation/controllers/auth_controller.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/ProgressPage.dart';
import 'package:meditation/pages/breathingExercise.dart';
import 'package:meditation/pages/checkin.dart';
import 'package:meditation/pages/downloadedcontentPage.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/components/home_feature.dart';
import 'package:meditation/pages/saveContentPage.dart';

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
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "NeuroMedita",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Alegreya',
                    letterSpacing: 3,
                  ),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Alegreya',
                ),
              ),
              Text(
                "We wish you have a good day.",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Source Sans Pro',
                ),
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, DownloadedContentPage.id);
                    },
                    child: features(
                      icon: Icons.download,
                      name: 'Download',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SaveContent.id);
                    },
                    child: features(
                      icon: Icons.favorite,
                      name: 'Favourite',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProgressPage.id);
                    },
                    child: features(
                      icon: Icons.track_changes,
                      name: 'Progress',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              //main features
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, breathingExercise.id);
                    },
                    child: mainFeatures(
                        image: 'images/exercisehome.png',
                        name: 'Breathing Exercise',
                        color: Color(0xFFFF5E2D5)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, musicPage.id);
                    },
                    child: mainFeatures(
                        image: 'images/music.png',
                        name: 'Music Therapy',
                        color: Color(0xFFFFFC97E)),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, mindGame.id);
                    },
                    child: mainFeatures(
                        image: 'images/gamehome.png',
                        name: 'Mind Game',
                        color: Color(0xFFA4DDBF)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CheckinPage.id);
                    },
                    child: mainFeatures(
                      image: 'images/moodhome.png',
                      name: 'Mood Check-in',
                      color: Colors.blue[100],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
