import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class reminderPage extends StatefulWidget {
  const reminderPage({Key? key}) : super(key: key);
  static String id = "reminderPage";

  @override
  State<reminderPage> createState() => _reminderPageState();
}

class _reminderPageState extends State<reminderPage> {
  bool light = true;
  TimeOfDay selectedTime = TimeOfDay.now();

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
                  SizedBox(height:40),
                  Padding(
                    padding: const EdgeInsets.only(bottom:20.0),
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
                        Transform.scale(scale: 1.5,
                          child: Switch(
                            //activeColor: Colors.green,
                            value: light,
                            onChanged:(bool value){
                              setState(() {
                                light = value;
                              });
                            },),
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
                        style:ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5562F9),
                        ),
                        onPressed: showTimePicker,
                        child: Text(
                          'Select Time',
                          style:TextStyle(
                            fontSize: 20,
                          ) ,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right:10),
                        child: Text(selectedTime.format(context),
                          style:
                          TextStyle(
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
                  onPressed: ()  {
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
    );
  }
}
