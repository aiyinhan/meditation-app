import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meditation/controllers/video_controller.dart';
import 'package:meditation/pages/breathingExercise.dart';

class UploadExercise extends StatefulWidget {
   UploadExercise ({Key? key}) : super(key: key);
  static String id ='Upload Exercise';

  @override
  State<UploadExercise> createState() => _UploadExerciseState();
}

class _UploadExerciseState extends State<UploadExercise> {
  final VideoController _uploadVideoController = VideoController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Upload Breathing Exercise',
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
                      onPressed: _uploadVideoController.pickVideo,
                      child: Text(
                        'Select Video',
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
                      _uploadVideoController.videoFile != null
                          ? _uploadVideoController.videoFile!.path
                          : 'No video selected',
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
                          _uploadVideoController.title = value;
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
                        try {
                          await _uploadVideoController.uploadVideo();
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
                                content: Text('Video uploaded successfully.',
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
                                      Navigator.pushNamed(context, breathingExercise.id);
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
                                content: Text(
                                  'An error occurred while uploading the vieo. Please try again.: $error',
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

