import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation/controllers/music_controller.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/pages/saveVideo.dart';
import 'PlayMusicPage.dart';

class saveMusic extends StatefulWidget {
  static String id = "saveMusic";
  const saveMusic({Key? key}) : super(key: key);

  @override
  State<saveMusic> createState() => _saveMusicState();
}

class _saveMusicState extends State<saveMusic> {
  bool _musicisTapped = false;
  bool _videoisTapped = false;
  MusicController _saveMusicController = MusicController();
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
              'Favourite Song',
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
                      color: _musicisTapped ? Colors.white : Colors.white54,
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
                      _videoisTapped = !_videoisTapped; // Toggle the tapped state
                    });
                    Navigator.pushNamed(context, saveVideo.id);
                  },
                  child: Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:  _musicisTapped ? Colors.white : Colors.white54,
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
              stream: _saveMusicController.getFavMusic(),
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
                      String artist = document['artist'];
                      String docid = document.id;
                      TextEditingController(text: title);
                      TextEditingController(text: artist);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            String songUrl = document['url'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayMusicPage(
                                  songUrl: songUrl,
                                  title: title,
                                  artist: artist,
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
                        subtitle: Text(
                          artist,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: ()  {
                              _saveMusicController.deleteFavoriteSong(docid);
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
