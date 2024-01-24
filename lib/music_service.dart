import 'package:cloud_firestore/cloud_firestore.dart';


class MusicService {
  static Future<int> fetchTotalMusicDuration(String userId) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('RegisterData')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('music_duration')) {
          return data['music_duration'] as int;
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

  static Future<void> saveMusicDuration(String userId,
      int durationInSeconds) async {
    try {
      await FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(userId)
          .set({'music_duration': durationInSeconds}, SetOptions(merge: true));
    } catch (e) {
      print('Error saving music duration: $e');
    }
  }
}

