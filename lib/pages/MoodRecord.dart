import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:intl/intl.dart';

class MoodRecord extends StatefulWidget {
  const MoodRecord({Key? key}) : super(key: key);
  static String id = "MoodRecord";

  @override
  State<MoodRecord> createState() => _MoodRecordState();
}

class _MoodRecordState extends State<MoodRecord> {
  final user = FirebaseAuth.instance.currentUser;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2008),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF8E97FD), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime startOfWeek = DateTime.utc(selectedDate.year,selectedDate.month,selectedDate.day-selectedDate.weekday+1);
    print('startweek: $startOfWeek');
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    print('endweek: $endOfWeek');
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items:[
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, homePage.id);
                },
                child: Icon(Icons.home,color: Colors.grey[700],)),
            label: ''),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, reminderPage.id);
                },
                child: Icon(Icons.timer)), label: ''),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, ProfilePage.id);
                },
                child: Icon(Icons.person_2)), label: ''),
      ],
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF8E97FD),
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        title: Text('Mood Record'),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Alegreya',
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Selected Date: ${DateFormat.yMMMMd().format(selectedDate)}',
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Alegreya',
              fontWeight: FontWeight.w600,
            ),),
            trailing: Icon(Icons.calendar_today),
            onTap: ()async{
              await _selectDate(context);
              setState(() {
              });
            }
          ),
          SizedBox(height: 20,),
          Expanded(
              child: ListView(
                children:[StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user?.uid) // Replace with the actual user ID
                  .collection('MoodRecord')
                  .doc(selectedDate.year.toString())
                  .collection('Months')
                  .doc(selectedDate.month.toString())
                  .collection('Days')
                  .where('date',
                      isGreaterThanOrEqualTo: startOfWeek,
                      isLessThanOrEqualTo: endOfWeek)
                  .orderBy('date', descending: false)
                  .snapshots(),
                builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child:
                          Text('No mood records found for the selected week.'));
                }
                 List<Widget> moodRecordWidgets = [];

                 snapshot.data!.docs.forEach((document) {
                  final moodRecordData = document.data() as Map<String, dynamic>;
                  final date = DateFormat.yMMMMd().format(moodRecordData['date'].toDate());
                  print(date);
                  final mood = moodRecordData['mood'];
                  final reasons = moodRecordData['reasons'].join(', ');


                  moodRecordWidgets.add(
                      Container(
                        width: 300, // Set your desired width
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: const [
                              Color(0xFFCBCFFF),
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mood: $mood',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Alegreya',
                              fontWeight: FontWeight.bold,
                            ),),
                            Text('Reasons: $reasons',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Source Sans Pro',
                                fontWeight: FontWeight.w300,

                              ),),
                            Text('Date: ${DateFormat.yMMMMd().format(moodRecordData['date'].toDate())}',
                              style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Source Sans Pro',
                              fontWeight: FontWeight.w300,

                            ),),
                          ],
                        ),
                      )
                  );
                });

                 return Column(
                  children: moodRecordWidgets,
                );
            },
          ),
              ],),),
        ],
      ),
    );
  }
}
