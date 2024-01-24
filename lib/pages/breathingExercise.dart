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

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reminder'),
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
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 300,
                backgroundColor: Colors.orange[200],
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Breathing Exercise',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                              Text(
                                'Practice and develop mindfulness',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Alegreya',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _videoController.userRole == 'admin',
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, UploadExercise.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.add_circle_rounded,
                                color: Colors.black54,
                                size: 27,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                  background: Opacity(
                    opacity: 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 70),
                      child: Image.asset(
                        'images/music.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: StreamBuilder<QuerySnapshot>(
            stream: _videoController.video,
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
                    String docid = document.id;
                    TextEditingController titleController =
                        TextEditingController(text: title);
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Color(0xFF1F265E),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
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
                                if (titleController.text.isEmpty) {
                                  _showErrorMessage(
                                      'Please fill in all fields');
                                } else {
                                  _videoController.updateSongMetadata(
                                    docid,
                                    titleController.text,
                                  );
                                  Navigator.of(context).pop();
                                }
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
        ),
      ),
    );
  }
}
