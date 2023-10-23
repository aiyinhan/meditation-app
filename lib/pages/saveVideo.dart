import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/pages/saveMusic.dart';
import 'package:meditation/pages/PlayVideo.dart';


class saveVideo extends StatefulWidget {
  const saveVideo({Key? key}) : super(key: key);
  static String id = 'saveVideo';

  @override
  State<saveVideo> createState() => _saveVideoState();
}

class _saveVideoState extends State<saveVideo> {
  final user = FirebaseAuth.instance.currentUser;
  bool _videoisTapped = false;
  bool _musicisTapped =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBCFFF),
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
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, reminderPage.id);
              },
              child: Icon(Icons.timer),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfilePage.id);
              },
              child: Icon(Icons.person_2),
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Favourite Video',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Source Sans Pro',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _musicisTapped = !_musicisTapped; // Toggle the tapped state
                    });
                    Navigator.pushNamed(context, saveMusic.id);
                  },
                  child: Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _musicisTapped  ? Colors.white : Colors.white54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.library_music),
                        Text('MUSIC'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _videoisTapped  = !_videoisTapped ; // Toggle the tapped state
                    });
                    Navigator.pushNamed(context, saveVideo.id);
                  },
                  child: Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _videoisTapped  ? Colors.white : Colors.white54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.video_collection),
                        Text('VIDEO'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('RegisterData')
                  .doc(user!.uid)
                  .collection('favoriteVideo')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // Update data
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var document = snapshot.data!
                          .docs[index]; // 0 to snapshot.data!.docs.length - 1
                      String title = document['title'];
                      String docid = document.id;
                      TextEditingController(text: title);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            String videoUrl = document['url'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayVideo(
                                  videoUrl: videoUrl,
                                  title: title,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.play_circle,
                            size: 30,
                            color: Colors.black87,
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),

                        trailing: IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('RegisterData')
                                  .doc(user!.uid)
                                  .collection('favoriteVideo')
                                  .doc(docid)
                                  .delete();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black,
                            )),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
