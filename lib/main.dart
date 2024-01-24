import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meditation/game/memorygame/home.dart';
import 'package:meditation/game/puzzlegame/screen/puzzleHome.dart';
import 'package:meditation/game/puzzlegame/screen/puzzleboard.dart';
import 'package:meditation/game/sudoku/sudokuLevelHome.dart';
import 'package:meditation/notification_service.dart';
import 'package:meditation/pages/MoodRecord.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/ProgressPage.dart';
import 'package:meditation/pages/RegisterPage.dart';
import 'package:meditation/pages/UploadSongPage.dart';
import 'package:meditation/pages/breathingExercise.dart';
import 'package:meditation/pages/checkin.dart';
import 'package:meditation/pages/downloadedcontentPage.dart';
import 'package:meditation/pages/forgotpass.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/loginpage.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/pages/UploadExercise.dart';
import 'package:meditation/pages/saveContentPage.dart';
import 'game/mathGame/mathLevelHome.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService.init();
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  void initState(){
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: user!=null ? homePage.id : loginpage.id,
      routes: {
        loginpage.id: (context) => loginpage(),
        RegisterPage.id: (context) => RegisterPage(),
        forgotPass.id: (context) => forgotPass(),
        homePage.id: (context) => homePage(),
        ProfilePage.id: (context) => ProfilePage(),
        reminderPage.id: (context) => reminderPage(),
        ProgressPage.id: (context) => ProgressPage(),
        CheckinPage.id: (context) => CheckinPage(),
        MoodRecord.id: (context) => MoodRecord(),
        musicPage.id: (context) => musicPage(),
        mindGame.id: (context) => mindGame(),
        breathingExercise.id: (context) => breathingExercise(),
        UploadSongPage.id: (context) => UploadSongPage(),
        UploadExercise.id: (context) => UploadExercise(),
        GameBoard.id: (context) => GameBoard(),
        Home.id: (context) => Home(),
        sudokuLevelPage.id: (context) => sudokuLevelPage(),
        MathLevelPage.id: (context) => MathLevelPage(),
        DownloadedContentPage.id: (context) => DownloadedContentPage(),
        puzzleHome.id: (context) => puzzleHome(),
        SaveContent.id: (context) => SaveContent(),
      },
    );
  }
}
