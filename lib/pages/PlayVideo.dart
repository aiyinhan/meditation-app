import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation/components/videodownloadbutton.dart';
import 'package:meditation/controllers/downloadVideo_controller.dart';
import 'package:meditation/pages/breathingExercise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class PlayVideo extends StatefulWidget {
  PlayVideo({Key? key, required this.videoUrl, required this.title})
      : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
  final String videoUrl;
  String title;
}

class _PlayVideoState extends State<PlayVideo> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool isFavorite = false;
  int _totalDurationInSeconds = 0;
  int _totalCompletedSessions = 0;
  bool _isVideoCompleted = false;
  late VideoDownloadController videodownloadController;

  void fetchBreathingExerciseData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('breathing_exercises')
          .doc('breathing_data');
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _totalDurationInSeconds = data['total_duration'] ?? 0;
          _totalCompletedSessions = data['total_completed_sessions'] ?? 0;
        });
      } else {
      //create new one
        docRef.set({
          'total_duration': 0,
          'total_completed_sessions': 0,
        });
      }
    }
  }

  void _saveBreathingExerciseInfo(
      int durationInSeconds, int completedSessions) async {
    print(
        "Updating Firestore: Duration: $durationInSeconds, Sessions: $completedSessions");
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update the total duration and total completed sessions
      _totalDurationInSeconds += durationInSeconds;
      _totalCompletedSessions += completedSessions;

      final docRef = FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('breathing_exercises')
          .doc('breathing_data');

      print(
          "Updated Values: Duration: $_totalDurationInSeconds , Sessions: $_totalCompletedSessions");
      // Save the updated data to Firestore
      await docRef.update({
        'total_duration': _totalDurationInSeconds,
        'total_completed_sessions': _totalCompletedSessions,
      });
    }
  }


  void _onVideoCompleted() {
    //if the video completed
    if (!_isVideoCompleted) {
      _isVideoCompleted = true;
      final durationListenedInMinutes =
          _videoPlayerController!.value.duration.inMinutes;
      print("Duration Listened: $durationListenedInMinutes seconds");
      final completedSessions = 1;
      _saveBreathingExerciseInfo(durationListenedInMinutes, completedSessions);
    }
  }

  @override
  void initState() {
    super.initState();
    videodownloadController =
        VideoDownloadController(widget.videoUrl, widget.title);
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
    );
    _videoPlayerController!.addListener(_onVideoCompleted);
    loadFavoriteStatus();
    fetchBreathingExerciseData();
  }

  @override
  void dispose() {
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _videoPlayerController?.removeListener(_onVideoCompleted);
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, breathingExercise.id);
                        _chewieController?.pause();
                      },
                      icon: Icon(Icons.arrow_back)),
                  Spacer(),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: VideoDownloadButton(
                      videodownloadController: videodownloadController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      highlightColor: Colors.grey,
                      onPressed: () => toggleFavoriteStatus(),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite ? Colors.pink : null,
                      ),
                      color: Color(0xFF03174C),
                    ),
                  ),
                ],
              ),
              Chewie(controller: _chewieController!),
            ],
          ),
        ),
      ),
    );
  }

  void loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.videoUrl) ?? false;
    });
  }

  void toggleFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteSongsCollection = FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('favoriteVideo');

      if (isFavorite) {
        await favoriteSongsCollection
            .where('url', isEqualTo: widget.videoUrl)
            .get()
            .then((snapshot) {
          for (final doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
      } else {
        await favoriteSongsCollection.add({
          'title': widget.title,
          'url': widget.videoUrl,
        });
      }
      setState(() {
        isFavorite = !isFavorite;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(widget.videoUrl, isFavorite);
    }
  }
  // void checkFavoriteStatus() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final favoriteSongsSnapshot = await FirebaseFirestore.instance
  //         .collection('RegisterData')
  //         .doc(user.uid)
  //         .collection('favoriteVideo')
  //         .where('url', isEqualTo: widget.videoUrl)
  //         .get();
  //     setState(() {
  //       isFavorite = favoriteSongsSnapshot.docs.isNotEmpty;
  //     });
  //   }
  // }
}
