import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';

import 'PlayMusicPage.dart';


class musicPage extends StatefulWidget {
  const musicPage({Key? key}) : super(key: key);
  static String id = "musicPage";

  @override
  State<musicPage> createState() => _musicPageState();
}

class _musicPageState extends State<musicPage> {

  @override
  void initState (){
    super.initState();
  }

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
                  child: Icon(Icons.home,color: Colors.grey[700],)),
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
        //background
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF8E97FD),
                Colors.white,
              ],
            ),
          ),
          child: Center(
            //music
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Music',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(
                          width: 330,
                          image: AssetImage('images/music therapy.jpg'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:50),
                      child: Container(
                        alignment: Alignment.center,
                          child: Column(
                            children: const [
                              Text(
                                "Relax Sounds",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                "Relax yourself with relax music.",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                  ],
                ),

                //listens to a stream of data and rebuilds itself whenever new data is received
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('musicMetadata').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var document = snapshot.data!.docs[index];
                            String title = document['title'];
                            String artist = document['artist'];
                            return ListTile(
                              leading: Icon(Icons.play_arrow),
                              title: Text(title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              )),
                              subtitle: Text(artist,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                              onTap: () {
                                String songUrl = document['url'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayMusicPage(songUrl: songUrl ,title: title,
                                      artist: artist,),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
