import 'package:cloud_firestore/cloud_firestore.dart';

class VideoService{
  static Future<int> fetchTotalMusicDuration(String userId) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('RegisterData').doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        // Check if the 'music_duration' key exists and return its value as an integer
        if (data != null && data.containsKey('video_duration') ) {
          return data['video_duration'] as int;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching total music duration: $e');
      return 0;
    }
  }

  static Future<void> saveMusicDuration(String userId, int durationInSeconds ,int session) async {
    try {
      await FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(userId)
          .set({'video_duration': durationInSeconds,'completed_session':session}, SetOptions(merge: true));
    } catch (e) {
      print('Error saving music duration: $e');
    }
  }
}