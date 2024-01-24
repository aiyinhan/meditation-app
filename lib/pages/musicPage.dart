import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation/components/music_icon.dart';
import 'package:meditation/controllers/music_controller.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/UploadSongPage.dart';
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
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final MusicController _musicController = MusicController();
  bool userRoleFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    await _musicController.getUserRole();
    setState(() {
      userRoleFetched = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    artistController.dispose();
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
              fontFamily: 'Alegreya',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Alegreya',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
        // Background
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 300,
                backgroundColor: Color(0xFFA6B9FF),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Relax Sounds',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                  background: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'images/relaxmusic.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                actions: <Widget>[
                  Visibility(
                    visible: _musicController.userRole == 'admin',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, UploadSongPage.id);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, right: 12),
                          child: Icon(
                            Icons.add_circle_rounded,
                            color: Colors.black54,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
          body: StreamBuilder<QuerySnapshot>( //querysnapshot represenrs the result of query
            stream: _musicController.music,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    TextEditingController titleController =
                        TextEditingController(text: title);
                    TextEditingController artistController =
                        TextEditingController(text: artist);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFFFFC97E),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          // Edit
                          Visibility(
                            visible: _musicController.userRole == 'admin',
                            child: musicIcon(
                              onPressed: () {
                                // Update the song metadata in Firestore
                                if (titleController.text.isEmpty ||artistController.text.isEmpty) {
                                  _showErrorMessage(
                                      'Please fill in all fields');
                                } else {
                                  _musicController.updateSongMetadata(
                                    docid,
                                    titleController.text,
                                    artistController.text,
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              operationName: 'Edit MetaData',
                              titleController: titleController,
                              artistController: artistController,
                              buttonText: 'Update',
                              icon: Icons.edit,
                            ),
                          ),
                          // Delete
                          Visibility(
                            visible: _musicController.userRole == 'admin',
                            child: musicIcon(
                              onPressed: () {
                                // Delete the song document from Firestore
                                _musicController.deleteSong(docid);
                                Navigator.of(context).pop();
                              },
                              operationName:
                                  'Are you sure you want to delete this song?',
                              titleController: titleController,
                              artistController: artistController,
                              buttonText: 'Delete',
                              icon: Icons.delete,
                            ),
                          ),
                        ],
                      ),
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
        ),
      ),
    );
  }
}
