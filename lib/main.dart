import 'package:flutter/material.dart';
import 'package:meditation/pages/MoodRecord.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/ProgressPage.dart';
import 'package:meditation/pages/RegisterPage.dart';
import 'package:meditation/pages/breathingExercise.dart';
import 'package:meditation/pages/checkin.dart';
import 'package:meditation/pages/downloaded.dart';
import 'package:meditation/pages/forgotpass.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/pages/reminderPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //initilization of Firebase app

  // other Firebase service initialization

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: RegisterPage(),
      initialRoute: breathingExercise.id,
      routes: {
        loginpage.id:(context)=> loginpage(),
        RegisterPage.id:(context)=> RegisterPage(),
        forgotPass.id:(context)=> forgotPass(),
        homePage.id:(context)=> homePage(),
        ProfilePage.id:(context)=> ProfilePage(),
        reminderPage.id:(context)=> reminderPage(),
        ProgressPage.id:(context)=> ProgressPage(),
        CheckinPage.id:(context)=> CheckinPage(),
        MoodRecord.id:(context)=> MoodRecord(),
        downloadMusic.id:(context)=> downloadMusic(),
        musicPage.id:(context)=> musicPage(),
        mindGame.id:(context)=> mindGame(),
        breathingExercise.id:(context)=> breathingExercise(),
      },
    );
  }
}
