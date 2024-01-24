import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation/notification_service.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz; // Import tz
import 'package:workmanager/workmanager.dart';
import '../main.dart';

class reminderPage extends StatefulWidget {
  const reminderPage({Key? key}) : super(key: key);
  static String id = "reminderPage";

  @override
  State<reminderPage> createState() => _reminderPageState();
}

class _reminderPageState extends State<reminderPage> {
  bool light = false;
  late TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0);
  bool isReminderSaved = false; // Track whether the reminder is saved
  bool isReminderEnabled = false;

  static tz.TZDateTime _scheduleDaily(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    //final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    final scheduledDate = tz.TZDateTime(tz.getLocation('Asia/Kuala_Lumpur'),
        now.year, now.month, now.day, time.hour, time.minute);
    print("scheduledDate:$scheduledDate");
    print("now:$now");
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  Future<void> scheduleReminder() async {
    NotificationService.showScheduledNotification(
        scheduleDate: _scheduleDaily(selectedTime),
        title: 'Daily Reminder',
        body: 'Take a break, breathe, and meditate.\nIt\'s time to Meditate!',
        payload: "meditation",
        id: 0);
    print("selectedtime:$selectedTime");
    await setReminderSetting(true);
  }

  Future<void> cancelReminder() async {
    await flutterLocalNotificationsPlugin.cancel(0);
    await setReminderSetting(false);
  }

  Future<void> setReminderSetting(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder_enabled', isEnabled);
  }

  Future<void> getReminderSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('daily_reminder_enabled') ?? false;
    setState(() {
      isReminderEnabled = isEnabled;
    });
  }

  Future<void> loadSelectedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final storedHour = prefs.getInt('selectedHour');
    final storedMinute = prefs.getInt('selectedMinute');

    if (storedHour != null && storedMinute != null) {
      setState(() {
        selectedTime = TimeOfDay(hour: storedHour, minute: storedMinute);
      });
    } else {
      selectedTime = TimeOfDay.now();
    }
  }

  Future<void> saveSelectedTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedHour', selectedTime.hour);
    await prefs.setInt('selectedMinute', selectedTime.minute);
  }

  void showTimePicker() async {
    TimeOfDay? pickedTime = await showMaterialTimePicker(
      context: context,
      selectedTime: selectedTime,
      onChanged: (newTime) {
        setState(() {
          selectedTime = newTime;
          saveSelectedTime();
        });
      },
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        saveSelectedTime();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getReminderSetting();
    loadSelectedTime();
  }

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
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, homePage.id);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 75,
                    ),
                    Text(
                      " Reminder",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    30.0,
                  ),
                  topRight: Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Get reminders',
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
                                    value: isReminderEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        isReminderEnabled = value;
                                      });
                                      if (value) {
                                        scheduleReminder(); //on
                                      } else {
                                        cancelReminder();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Select your meditate time',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Alegreya',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: showTimePicker,
                                      icon: Icon(
                                        Icons.add_alarm_rounded,
                                        size: 40,
                                        color: Colors.indigo[300],
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
                        ],
                      ),

                      SizedBox(height: 100),
                      //save and close button
                      Center(
                        child: SizedBox(
                          height: 65,
                          width: 350,
                          child: MaterialButton(
                            padding: EdgeInsets.all(15),
                            onPressed: () {
                              if (isReminderEnabled) {
                                //light =true
                                scheduleReminder();
                                print('reminder save');
                                isReminderSaved = true;
                              } else {
                                isReminderSaved = false;
                                cancelReminder();
                                print("cancel reminder");
                              }
                              Navigator.pushNamed(context, homePage.id);
                            },
                            color: Color(0xFF8E97FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
            ),
          )
        ]),
      ),
    );
  }
}
