import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize the VideoPlayerController with the video URL
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    // Initialize the ChewieController with CupertinoControls
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
      customControls: CupertinoControls(
        backgroundColor: Color(0xFF8C8C8C),
        iconColor: Colors.white,
      ),
    );
    loadFavoriteStatus();
    fetchBreathingExerciseData();
    // Add a one-time listener to detect when the video playback reaches the end
    _videoPlayerController!.addListener(_onVideoInitialized);
  }

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
        // If the document exists, update the total duration and total completed sessions
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _totalDurationInSeconds = data['total_duration'] ?? 0;
          _totalCompletedSessions = data['total_completed_sessions'] ?? 0;
        });
      } else {
        // If the document does not exist, create it with initial values
        docRef.set({
          'total_duration': 0,
          'total_completed_sessions': 0,
        });
      }
    }
  }
  void _onVideoInitialized() {
    // Start the video playback once the video is initialized
    _videoPlayerController!.play();
    // Add a one-time listener to detect when the video playback reaches the end
    _videoPlayerController!.addListener(_onVideoCompleted);
  }

  void _onVideoCompleted() {
    // Check if the video was already completed
    if (!_isVideoCompleted) {
      // Set the flag to true to avoid multiple updates
      _isVideoCompleted = true;
      // Calculate the duration listened (completed) in seconds
      final durationListenedInSeconds = _videoPlayerController!.value.duration.inSeconds;
      // Mark the session as completed (you can increment this as needed)
      final completedSessions = 1;
      // Save the duration and completed sessions to Firestore
      _saveBreathingExerciseInfo(durationListenedInSeconds, completedSessions);
    }
  }

  void _saveBreathingExerciseInfo(int durationInSeconds, int completedSessions) async {
    print("Updating Firestore: Duration: $durationInSeconds, Sessions: $completedSessions");
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

      // Save the updated data to Firestore
      await docRef.update({
        'total_duration': _totalDurationInSeconds,
        'total_completed_sessions': _totalCompletedSessions,
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //background
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: const [
                  Colors.blueAccent,
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, breathingExercise.id);
                        },
                        icon: Icon(Icons.arrow_back)),
                    Spacer(),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alegreya',
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.download),
                        color: Color(0xFF03174C),
                      ),
                    ),
                    //favourite
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
                  ]),
                  SizedBox(
                      height: 600,
                      child: Chewie(controller: _chewieController!)),
                ],
              ),
            ),
          ),
        ]),
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
    // Get the current user ID
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteSongsCollection = FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('favoriteVideo');

      if (isFavorite) {
        // Remove the song from favorites in Firestore
        await favoriteSongsCollection
            .where('url', isEqualTo: widget.videoUrl)
            .get()
            .then((snapshot) {
          for (final doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
      } else {
        // Add the song to favorites in Firestore
        await favoriteSongsCollection.add({
          'title': widget.title,
          'url': widget.videoUrl,
        });
      }

      // Update the favorite status locally
      setState(() {
        isFavorite = !isFavorite;
      });
      // Update the favorite status in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(widget.videoUrl, isFavorite);
    }
  }


  void checkFavoriteStatus() async {
    // Get the current user ID
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteSongsSnapshot = await FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('favoriteVideo')
          .where('url', isEqualTo: widget.videoUrl)
          .get();
      setState(() {
        isFavorite = favoriteSongsSnapshot.docs.isNotEmpty;
      });
    }
  }
}
