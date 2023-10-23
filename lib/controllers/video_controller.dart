import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class VideoController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? videoFile;
  String title = '';
  String userRole = '';

  final video = FirebaseFirestore.instance.collection('videoMetadata').snapshots();

  Future<void> uploadVideo() async {
    if (videoFile == null || title.isEmpty) {
      // Ensure all fields are filled
      return;
    }
    try {
      // Upload song file to Firebase Storage
      Reference storageRef =
      _storage.ref().child('video/${videoFile!.path}');
      await storageRef.putFile(videoFile!);
      String? videoUrl = await storageRef.getDownloadURL();
      // Upload song metadata to Firestore
      await _firestore.collection('videoMetadata').add({
        'title': title,
        'url': videoUrl,
      });
      // Clear form fields and show success message
      videoUrl = null;
      title = '';
    } catch (error) {
      // Show error message
      throw error;
    }
  }

  Future<void> pickVideo() async {
    final picker = FilePicker.platform;
    FilePickerResult? result = await picker.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.first.path!); //retrieves the path of the first selected file
      videoFile = file;
      //String videoName = DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';
    }
  }

  Future<void> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore
          .collection('RegisterData')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        userRole = snapshot.get('Role') ?? '';
        print(userRole); // Assign the user's role to the userRole variable
      }
    }
  }

  Future<void> updateSongMetadata(String docid, String newTitle) async {
    await _firestore.collection('videoMetadata').doc(docid).update({
      'title': newTitle,
    });
  }

  Future<void> deleteSong(String docid) async {
    await _firestore.collection('videoMetadata').doc(docid).delete();
  }

}
