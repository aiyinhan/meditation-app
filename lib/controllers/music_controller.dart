import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class MusicController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference musicMetadataCollection = FirebaseFirestore.instance.collection('musicMetadata');
  final music = FirebaseFirestore.instance.collection('musicMetadata').snapshots();
  final user = FirebaseAuth.instance.currentUser;

  String userRole = '';
  File? MsongFile;
  String Mtitle = '';
  String Martist = '';
  File? get songFile => MsongFile;
  String get title => Mtitle;
  String get artist => Martist;

  bool isPlaying = false;
  AudioPlayer justAudioPlayer = AudioPlayer();
  List<Song> songs = []; //song model
  bool isFavorite = false;

  //upload song
  void pickSong() async {
    final picker = FilePicker.platform;
    FilePickerResult? result = await picker.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.first.path!); //retrieves the path of the first selected file
      MsongFile = file;
    }
  }

  Future<void> uploadSong() async {
    if (MsongFile == null || Mtitle.isEmpty || Martist.isEmpty) {
      return;
    }
    try {
      Reference storageRef =
      FirebaseStorage.instance.ref().child('song/${MsongFile!.path}'); //! ensure a non null path when file is selected
      await storageRef.putFile(MsongFile!);
      String songUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('musicMetadata').add({
        'title': Mtitle,
        'artist': Martist,
        'url': songUrl,
        'isFavourite': false,
      });
      MsongFile = null;
      Mtitle = '';
      Martist = '';
    } catch (error) {
      print('Error: $error');
    }
  }

  //music page
  Future<void> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore
          .collection('RegisterData')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        userRole = snapshot.get('Role') ?? '';
      }
    }
  }

  Future<void> updateSongMetadata(String docid, String newTitle,
      String newArtist) async {
    await _firestore.collection('musicMetadata').doc(docid).update({
      'title': newTitle,
      'artist': newArtist,
    });
  }

  Future<void> deleteSong(String docid) async {
    await _firestore.collection('musicMetadata').doc(docid).delete();
  }

//saveMusic
void deleteFavoriteSong (String docid)async{
  await _firestore
      .collection('RegisterData')
      .doc(user!.uid)
      .collection('favorite')
      .doc(docid)
      .delete();
}

  Stream<QuerySnapshot<Object?>> getFavMusic() {
    return _firestore
        .collection('RegisterData')
        .doc(user!.uid)
        .collection('favorite')
        .snapshots();
  }

  


}