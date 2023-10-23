import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/UploadExercise.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import '../components/video_icon.dart';
import '../controllers/video_controller.dart';
import 'PlayVideo.dart';


class breathingExercise extends StatefulWidget {
  const breathingExercise({Key? key}) : super(key: key);
  static String id = "breathingExercise";
  @override
  State<breathingExercise> createState() => _breathingExerciseState();
}

class _breathingExerciseState extends State<breathingExercise> {

  final VideoController _videoController = VideoController();
  bool userRoleFetched = false;


  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    await _videoController.getUserRole();
    setState(() {
      userRoleFetched = true;
    });
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, homePage.id);
                    },
                    child: Icon(Icons.arrow_back, size: 30),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Breathing Exercise',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UploadExercise.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 12, bottom: 20),
                      child: Icon(
                        Icons.add_circle_rounded,
                        color: Colors.black54,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric( horizontal: 10),
                child: Column(children: [
                  Container(
                    width: 600,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.orange[100],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Mindfulness',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                'Pratice and develop \n mindfulness',
                                style: TextStyle(
                                  fontSize: 20,
                                  //fontWeight: FontWeight.bold,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'images/music.png',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:5),
                  Divider(
                    thickness: 2,
                    color: Colors.black26,
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: _videoController.video,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Update data
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var document =
                            snapshot.data!.docs[index]; // 0 to snapshot.data!.docs.length - 1
                            String title = document['title'];
                            String docid = document.id;
                            TextEditingController titleController =
                            TextEditingController(text: title);
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${index + 1}',
                                  // Add 1 to index to start the list from 1 instead of 0
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Color(0xFF1F265E),
                                // Customize the color of the CircleAvatar
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
                                '2-3min',
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
                                  // Edit
                                  Visibility(
                                    visible: _videoController.userRole == 'admin',
                                    child: VideoIcon(
                                      onPressed: () {
                                        // Update the song metadata in Firestore
                                        _videoController.updateSongMetadata(
                                          docid,
                                          titleController.text,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      operationName: 'Edit MetaData',
                                      titleController: titleController,
                                      buttonText: 'Update',
                                      icon: Icons.edit,
                                    ),
                                  ),
                                  // // Delete
                                  Visibility(
                                    visible: _videoController.userRole == 'admin',
                                    child: VideoIcon(
                                      onPressed: () {
                                        // Delete the song document from Firestore
                                        _videoController.deleteSong(docid);
                                        Navigator.of(context).pop();
                                      },
                                      operationName:
                                      'Are you sure you want to delete this video?',
                                      titleController: titleController,
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
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
