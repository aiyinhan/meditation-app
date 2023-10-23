import 'package:flutter/material.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/controllers/music_controller.dart';

class UploadSongPage extends StatefulWidget {
  static String id = "UploadSongPage";
  @override
  _UploadSongPageState createState() => _UploadSongPageState();
}

class _UploadSongPageState extends State<UploadSongPage> {
  final MusicController _uploadSongController = MusicController();
  bool showSpinner =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Upload Song',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Alegreya', //
            ),
          ),
        ),
        backgroundColor: Color(0xFF8E97FD),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                      ),
                      onPressed: _uploadSongController.pickSong,
                      child: Text(
                        'Select Song',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _uploadSongController.songFile != null
                          ? _uploadSongController.songFile!.path
                          : 'No song selected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Alegreya',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Source Sans Pro',
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _uploadSongController.Mtitle = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Artist',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Source Sans Pro',
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _uploadSongController.Martist = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                      ),
                      onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try{
                          await _uploadSongController.uploadSong();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Alegreya',
                                  ),
                                ),
                                content: Text('Song uploaded successfully.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Alegreya',
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Alegreya',
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, musicPage.id);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (error) {
                          // Show error message
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Alegreya',
                                  ),),
                                content: Text('An error occurred while uploading the song. Please try again.: $error',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Alegreya',
                                  ),),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } finally {
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
