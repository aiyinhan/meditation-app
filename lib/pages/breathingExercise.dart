import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:video_player/video_player.dart';

class breathingExercise extends StatefulWidget {
  const breathingExercise({Key? key}) : super(key: key);
  static String id = "breathingExercise";
  @override
  State<breathingExercise> createState() => _breathingExerciseState();
}


class _breathingExerciseState extends State<breathingExercise> {

  List<String> musicPaths = [];
  Future<void> loadMusicList() async {
    // Fetch music files from Firebase Storage
    Reference referenceRoot = FirebaseStorage.instance.ref();
    print(referenceRoot);
    Reference referenceDirVideo = referenceRoot.child('video');
    print(referenceDirVideo);
    // const downloadUrl = await audioRef.getDownloadURL();
    // print(audioRef);
    // Reference musicRef = FirebaseStorage.instance.ref().child('music');
    ListResult result =  await referenceDirVideo.listAll();
    // // Store the music file paths in the list
    List<String> paths = result.items.map((item) => item.fullPath).toList();
    Reference musicRef = FirebaseStorage.instance.ref().child(paths as String);
    String musicUrl = await musicRef.getDownloadURL();
    print(musicUrl);
  }

  Future<void> playMusic(String musicPath) async {
    // Get the download URL for the music file
    Reference musicRef = FirebaseStorage.instance.ref().child(musicPath);
    String musicUrl = await musicRef.getDownloadURL();
    print(musicUrl);
    // Play the music file using just_audio package
  }

    void initState() {
      loadMusicList();
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
                  child: Icon(Icons.home, color: Colors.grey[700],)),
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //    //builder: (context) => PlayMusicPage(songUrl: songUrl ,title: title,
                              //       artist: artist,),
                              //   ),
                              // );
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
