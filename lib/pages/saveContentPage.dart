import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';

import '../controllers/music_controller.dart';
import 'PlayMusicPage.dart';
import 'PlayVideo.dart';

class SaveContent extends StatefulWidget {
  const SaveContent({Key? key}) : super(key: key);
  static String id = "save content";

  @override
  State<SaveContent> createState() => _SaveContentState();
}

class _SaveContentState extends State<SaveContent> {
  bool _showMusic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, homePage.id);
            },
          ),
          elevation: 0,
          backgroundColor: Color(0xFF8E97FD),
          title: Text(
            _showMusic ? 'Favourite Music List' : 'Favourite Video List',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Toggle the tapped state
                      setState(() {
                        _showMusic = true; // Show music content
                      });
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _showMusic ? Colors.blue[50] : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
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
                        _showMusic = false; // Show music content
                      });
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _showMusic ? Colors.white : Colors.blue[50],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
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
              Expanded(
                child: _showMusic
                    ? FavouriteMusicList()
                    : FavouriteVideoList(), // Conditionally render content
              ),
            ],
          ),
        ));
  }
}

class FavouriteMusicList extends StatefulWidget {
  const FavouriteMusicList({Key? key}) : super(key: key);

  @override
  State<FavouriteMusicList> createState() => _FavouriteMusicListState();
}

class _FavouriteMusicListState extends State<FavouriteMusicList> {
  MusicController _saveMusicController = MusicController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _saveMusicController.getFavMusic(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Update data
        if (snapshot.hasData) {
          return ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => SizedBox(height: 1),
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              String title = document['title'];
              String artist = document['artist'];
              String docid = document.id;
              TextEditingController(text: title);
              TextEditingController(text: artist);

              return Column(children: [
                Container(
                  height: 85,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Radio(
                          value: "",
                          groupValue: "",
                          activeColor: Color(0xFF8E97FD),
                          onChanged: (index) {}),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize:
                                    21, 
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                            Text(
                              artist,
                              style: TextStyle(
                                fontSize:
                                    16, 
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
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
                    ],
                  ),
                ),
              ]);
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
        }
        return CircularProgressIndicator.adaptive();
      },
    );
  }
}


class FavouriteVideoList extends StatefulWidget {
  const FavouriteVideoList({Key? key}) : super(key: key);

  @override
  State<FavouriteVideoList> createState() => _FavouriteVideoListState();
}

class _FavouriteVideoListState extends State<FavouriteVideoList> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user!.uid)
          .collection('favoriteVideo')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => SizedBox(height: 3),
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              String title = document['title'];
              String docid = document.id;
              TextEditingController(text: title);

              return Column(children: [
                Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Radio(
                          value: "",
                          groupValue: "",
                          activeColor: Color(0xFF8E97FD),
                          onChanged: (index) {}),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                      ),
                      IconButton(
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
                          size: 33,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
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
        }
        return CircularProgressIndicator.adaptive();
      },
    );
  }
}
