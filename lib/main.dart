import 'package:flutter/material.dart';
import 'package:meditation/game/memorygame/home.dart';
import 'package:meditation/game/puzzlegame/screen/puzzleboard.dart';
import 'package:meditation/game/sudoku/sudokuLevelHome.dart';
import 'package:meditation/pages/MoodRecord.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/ProgressPage.dart';
import 'package:meditation/pages/RegisterPage.dart';
import 'package:meditation/pages/UploadSongPage.dart';
import 'package:meditation/pages/breathingExercise.dart';
import 'package:meditation/pages/checkin.dart';
import 'package:meditation/pages/forgotpass.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/pages/UploadExercise.dart';
import 'package:meditation/pages/saveMusic.dart';
import 'package:meditation/pages/saveVideo.dart';
import 'package:meditation/pages/downloadVideo.dart';
import 'package:provider/provider.dart';
import 'package:meditation/controllers/download_controller.dart';
import 'game/mathGame/mathLevelHome.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notification plugin
  final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create the notification channel
  const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
    'daily_reminder_channel_id', // Channel ID
    'Daily Reminder',  // Channel Name
    //'Daily meditation reminder', // Channel Description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  tz.initializeTimeZones();

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
      initialRoute: mindGame.id,
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
        musicPage.id:(context)=> musicPage(),
        mindGame.id:(context)=> mindGame(),
        breathingExercise.id:(context)=> breathingExercise(),
        UploadSongPage.id:(context)=> UploadSongPage(),
        UploadExercise.id:(context)=> UploadExercise(),
        saveMusic.id:(context)=> saveMusic(),
        saveVideo.id:(context)=> saveVideo(),
        downloadVideo.id:(context)=> downloadVideo(),
        GameBoard.id:(context)=> GameBoard(),
        Home.id:(context)=> Home(),
        sudokuLevelPage.id:(context)=> sudokuLevelPage(),
        MathLevelPage.id:(context)=> MathLevelPage(),
      },
    );
  }
}
