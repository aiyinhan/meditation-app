import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation/controllers/download_controller.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/models/song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_downloadbutton.dart';
import '../music_service.dart';

class PlayMusicPage extends StatefulWidget {
  final String songUrl;
  String artist;
  String title;

  PlayMusicPage({
    required this.songUrl,
    required this.title,
    required this.artist,
  });

  @override
  _PlayMusicPageState createState() => _PlayMusicPageState();
}

class _PlayMusicPageState extends State<PlayMusicPage> {
  bool isPlaying = false;
  AudioPlayer justAudioPlayer = AudioPlayer();
  List<Song> songs = []; //song model
  int currentIndex = 0;
  double currentSliderValue = 0.0;
  Duration audioDuration = Duration.zero;
  bool isFavorite = false;
  Song? song;
  Duration startPosition = Duration.zero;
  int _currentDurationInSeconds = 0;
  bool _isSongCompleted = false;
  bool _isTimerStarted = false;
  bool isUserInteracting = false;
  late DownloadController musicdownloadController;

  Future<void> playPauseMusic() async {
    if (isPlaying) {
      await justAudioPlayer.pause();
    } else {
      await justAudioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> stopMusic() async {
    await justAudioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void skipToPreviousSong() {
    if (currentIndex > 0) {
      currentIndex--;
    } else {
      currentIndex =
          songs.length - 1; // Loop to the last song if its the first song
    }
    justAudioPlayer.setUrl(songs[currentIndex].url).then((_) {
      final duration = justAudioPlayer.duration;
      if (isPlaying && duration != null) {
        _cancelMusicTimer();
        _startMusicTimer(duration);
        justAudioPlayer.load();
        justAudioPlayer.play();
      }
      setState(() {
        widget.title = songs[currentIndex].title; // Update title
        widget.artist = songs[currentIndex].artist; // Update artist
      });
      _resetSongCompletedFlag();
    }).catchError((error) {
      print('Error setting song URL: $error');
    });
  }

  void skipToNextSong() {
    if (currentIndex < songs.length - 1) {
      currentIndex++;
    } else {
      currentIndex = 0;
    }
    justAudioPlayer.setUrl(songs[currentIndex].url).then((_) {
      final duration = justAudioPlayer.duration;
      if (isPlaying && duration != null) {
        _cancelMusicTimer();
        _startMusicTimer(duration);
        playPauseMusic();
      }
      setState(() {
        widget.title = songs[currentIndex].title;
        widget.artist = songs[currentIndex].artist;
      });
      _resetSongCompletedFlag();
    }).catchError((error) {
      print('Error setting song URL: $error');
    });
  }

  void _saveMusicDuration(int durationListenedInSeconds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        int totalMusicDuration =
            await MusicService.fetchTotalMusicDuration(user.uid);
        totalMusicDuration +=
            (durationListenedInSeconds ~/ 60); // Convert seconds to mins
        await FirebaseFirestore.instance
            .collection('RegisterData')
            .doc(user.uid)
            .set({'music_duration': totalMusicDuration},
                SetOptions(merge: true));
        print(
            'Duration saved to Firestore: ${durationListenedInSeconds ~/ 60} minutes');
        print('Total duration in Firestore: $totalMusicDuration minutes');
      } catch (e) {
        print('Error saving music duration: $e');
      }
    }
  }

  void _startMusicTimer(Duration? totalDuration) {
    print('_startMusicTimer called');
    if (!_isTimerStarted && totalDuration != null) {
      _isTimerStarted =
          true; // Set the flag to true so that the timer is not start again,avoid multiple start
      Timer.periodic(Duration(seconds: 1), (Timer timer) async {
        final currentPosition = justAudioPlayer.position;
        final durationListened = (currentPosition - startPosition).inSeconds;
        setState(() {
          _currentDurationInSeconds = durationListened;
        });
        if (_isSongCompleted) {
          timer.cancel();
          _saveMusicDuration(durationListened);
        }
      });
    }
  }

  void _cancelMusicTimer() {
    final currentPosition = justAudioPlayer.position;
    final durationListened = (currentPosition - startPosition).inSeconds;
    _saveMusicDuration(durationListened);
  }

  void _resetSongCompletedFlag() {
    _isSongCompleted = false;
  }

  void initAudioPlayer() async {
    try {
      await justAudioPlayer.setUrl(widget.songUrl);
      await justAudioPlayer.load();
      final duration = justAudioPlayer.duration;
      setState(() {
        audioDuration = duration ?? Duration.zero;
      });
      justAudioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isSongCompleted = true;
          // Save the music duration when the song is completed
          final currentPosition = justAudioPlayer.position;
          final durationListened = (currentPosition - startPosition).inSeconds;
          _isSongCompleted = false;
          _saveMusicDuration(durationListened);
        } else if (state.processingState == ProcessingState.ready) {
          if (state.playing) {
            // Playback is starting or resuming
            _startMusicTimer(audioDuration);
            setState(() {
              isPlaying = true;
            });
          } else {
            // Playback is paused or stopped
            setState(() {
              isPlaying = false;
            });
          }
        }
      });
      justAudioPlayer.positionStream.listen((position) {
        if (position.inMilliseconds <= audioDuration.inMilliseconds) {
          setState(() {
            currentSliderValue = position.inMilliseconds.toDouble();
          });
        } else {
          setState(() {
            currentSliderValue = audioDuration.inMilliseconds.toDouble();
          });
        }
      });
      print("audio duration $audioDuration");
      loadFavoriteStatus();
      loadSongsFromFirestore(); // Load the list of songs from Firestore
      _startMusicTimer(audioDuration);
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    musicdownloadController =
        DownloadController(widget.songUrl, widget.title); //download function
    justAudioPlayer = AudioPlayer();
    justAudioPlayer.setUrl(widget.songUrl).catchError((error) {
      print('Error setting song URL: $error');
    });
    FirebaseFirestore.instance
        .collection('musicMetadata')
        .get()
        .then((snapshot) {
      setState(() {
        songs = snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList();
      });
    }).catchError((error) {
      print('Error retrieving songs: $error');
    });
    checkFavoriteStatus();
    initAudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelMusicTimer();
    justAudioPlayer.dispose();
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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20, bottom: 100, left: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, musicPage.id);
                              stopMusic();
                              _cancelMusicTimer();
                            },
                            icon: Icon(Icons.arrow_back)),
                        Spacer(),
                        //download
                        Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: MusicDownloadButton(
                              musicdownloadController: musicdownloadController,
                            )),
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
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: isFavorite
                                  ? Colors.pink
                                  : null, 
                            ),
                            color: Color(0xFF03174C),
                          ),
                        ),
                      ]),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.artist,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                      SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.only(right: 45),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //skip previous
                            IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                size: 60,
                              ),
                              onPressed: () {
                                skipToPreviousSong();
                              },
                            ),
                            //pause
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 0, bottom: 0),
                              child: IconButton(
                                onPressed: playPauseMusic,
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  size: 60,
                                ),
                              ),
                            ),

                            //skip next
                            IconButton(
                              icon: Icon(Icons.skip_next, size: 60),
                              onPressed: () {
                                skipToNextSong();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      StreamBuilder<Duration>(
                          stream: justAudioPlayer.positionStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Duration position = snapshot.data!;
                              if (!isUserInteracting) {
                                currentSliderValue =
                                    position.inMilliseconds.toDouble();
                              }
                              return SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white.withOpacity(0.4),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 14.0),
                                ),
                                child: Column(
                                  children: [
                                    Slider(
                                      activeColor: Colors.white,
                                      inactiveColor:
                                          Colors.white.withOpacity(0.3),
                                      value: currentSliderValue.clamp(
                                          0.0,
                                          audioDuration.inMilliseconds
                                              .toDouble()),
                                      min: 0.0,
                                      max: audioDuration.inMilliseconds
                                          .toDouble(),
                                      onChanged: (double value) {
                                        setState(() {
                                          isUserInteracting = true;
                                          currentSliderValue = value;
                                        });
                                      },
                                      onChangeEnd: (double value) {
                                        setState(() {
                                          isUserInteracting = false;
                                        });
                                        justAudioPlayer.seek(Duration(
                                            milliseconds: value.round()));
                                      },
                                    ),
                                    if (audioDuration.inMilliseconds > 0)
                                      Text(
                                        _getFormattedDuration(
                                            currentSliderValue),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  String _getFormattedDuration(double value) {
    final totalSeconds = value ~/ 1000; // Convert milliseconds to seconds
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteSongsSnapshot = await FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('favorite')
          .where('url', isEqualTo: widget.songUrl)
          .get();
      setState(() {
        isFavorite = favoriteSongsSnapshot.docs.isNotEmpty;
      });
    }
  }

  void loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.songUrl) ?? false;
    });
  }

  void toggleFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteSongsCollection = FirebaseFirestore.instance
          .collection('RegisterData')
          .doc(user.uid)
          .collection('favorite');

      if (isFavorite) {
        //remove
        await favoriteSongsCollection
            .where('url', isEqualTo: widget.songUrl)
            .get()
            .then((snapshot) {
          for (final doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
      } else {
        //add
        await favoriteSongsCollection.add({
          'title': widget.title,
          'artist': widget.artist,
          'url': widget.songUrl,
        });
      }
      setState(() {
        isFavorite = !isFavorite;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(widget.songUrl, isFavorite);
    }
  }

  void loadSongsFromFirestore() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('musicMetadata').get();
    setState(() {
      songs = snapshot.docs.map((doc) {
        final data = doc.data();
        if (data['isFavorite'] == null) {
          data['isFavorite'] = false;
        }
        return Song.fromJson(data);
      }).toList();
    });
  }
}
