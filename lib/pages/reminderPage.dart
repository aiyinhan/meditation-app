import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:timezone/timezone.dart' as tz; // Import tz

import '../main.dart';

class reminderPage extends StatefulWidget {
  const reminderPage({Key? key}) : super(key: key);
  static String id = "reminderPage";

  @override
  State<reminderPage> createState() => _reminderPageState();
}

class _reminderPageState extends State<reminderPage> {
  bool light = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isReminderSaved = false; // Track whether the reminder is saved
  late tz.Location _local;

  Future<void> scheduleReminder() async {
    final now = DateTime.now();
    final selectedDateTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_reminder_channel_id',
      'Daily Reminder',
      importance: Importance.high,
      priority: Priority.high,
    );
    // Convert selectedDateTime to TZDateTime
    final scheduledTime = tz.TZDateTime.local(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    // Schedule the reminder
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Daily Reminder', // Title
      'It\'s time to meditate!', // Body
      scheduledTime, // Scheduled time as TZDateTime
      NotificationDetails(android: androidPlatformChannelSpecifics),
      //androidScheduleMode: androidAllowWhileIdle,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  Future<void> cancelReminder() async {
    // Cancel the reminder by its ID
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  void showTimePicker() {
    showMaterialTimePicker(
      context: context,
      selectedTime: selectedTime,
      onChanged: (newTime) {
        setState(() {
          selectedTime = newTime;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize _local using tz.initializeTimeZones
    _local = tz.getLocation('Asia/Kuala_Lumpur'); // Replace 'your_timezone_identifier' with the actual timezone identifier
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8E97FD),
        toolbarHeight: 80,
        title: Text('Reminder'),
        titleTextStyle: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'Alegreya',
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFDDE0FD),
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 20,top: 20),
              //   child: Text(
              //     'Use reminders to help from your daily',
              //     style: TextStyle(
              //       fontSize: 20,
              //       color: Colors.grey[600],//0xFF5562F9),
              //       fontWeight: FontWeight.bold,
              //       fontFamily: 'Alegreya',
              //   ),),
              // ),
              // Text(
              //   ' meditation routine',
              //     style: TextStyle(
              //       fontSize: 20,
              //       color: Colors.grey[600],
              //       fontWeight: FontWeight.bold,
              //       fontFamily: 'Alegreya',
              //     ),
              // ),
              //
              SizedBox(height: 50),

              //set reminder
              Container(
                width: 380,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Get daily reminders',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya',
                            ),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              //activeColor: Colors.green,
                              value: light,
                              onChanged: (bool value) {
                                setState(() {
                                  light = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'What time would you like to mediate?',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alegreya',
                      ),
                    ),
                    SizedBox(height: 25),

                    //selected time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5562F9),
                          ),
                          onPressed: showTimePicker,
                          child: Text(
                            'Select Time',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            selectedTime.format(context),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70),

              //save and close button
              Center(
                child: SizedBox(
                  height: 65,
                  width: 350,
                  child: MaterialButton(
                    padding: EdgeInsets.all(15),
                    onPressed: () {
                      if (light) { //light =true
                        // Save the reminder logic here
                        scheduleReminder();
                        print('reminder save');
                        isReminderSaved = true;// Set the flag to indicate that the reminder is saved

                      } else {
                        // Handle case where reminder is not saved
                        isReminderSaved = false;
                        cancelReminder();
                      }
                      Navigator.pushNamed(context, homePage.id);
                    },
                    color: Color(0xFF8E97FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Save and Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
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
