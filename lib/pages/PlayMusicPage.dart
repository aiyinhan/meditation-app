import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation/pages/musicPage.dart';
import 'package:meditation/song_model.dart';

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
  AudioPlayer audioPlayer = AudioPlayer();
  List<Song> songs = []; //song model
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setUrl(widget.songUrl).catchError((error) {
      print('Error setting song URL: $error');
    });
    FirebaseFirestore.instance.collection('musicMetadata').get().then((snapshot) {
      setState(() {
        songs = snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList();
      });
    }).catchError((error) {
      print('Error retrieving songs: $error');
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic() async {
    await audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }
  void skipToPreviousSong() {
    if (currentIndex > 0) {
      currentIndex--;
      audioPlayer.setUrl(songs[currentIndex].url).then((_) {
        if (isPlaying) {
          playMusic();
        }
        setState(() {
          widget.title = songs[currentIndex].title; // Update the title
          widget.artist = songs[currentIndex].artist; // Update the artist
        });
      }).catchError((error) {
        print('Error setting song URL: $error');
      });
    }
  }

  void skipToNextSong() {
    if (currentIndex < songs.length - 1) {
      currentIndex++;
      audioPlayer.setUrl(songs[currentIndex].url).then((_) {
        if (isPlaying) {
          playMusic();
        }
        setState(() {
          widget.title = songs[currentIndex].title; // Update the title
          widget.artist = songs[currentIndex].artist; // Update the artist
        });
      }).catchError((error) {
        print('Error setting song URL: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:Color(0xFF8E97FD),
      // ),
      body: SafeArea(
        //background
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: const [
                    Color(0xFF8E97FD),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:20,bottom: 100,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.pushNamed(context, musicPage.id);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25,weight: 40,),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Title:',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Artist: ${widget.artist}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                                  // Call a function to skip to the previous song
                                  skipToPreviousSong();
                                },
                              ),

                              //pause
                              IconButton(
                                onPressed: () {
                                  if (isPlaying) {
                                    pauseMusic();
                                  } else {
                                    playMusic();
                                  }
                                },
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow, //if true then pause, false then arrow
                                  size: 60,
                                ),
                              ),

                              //skip next
                              IconButton(
                                icon: Icon(Icons.skip_next, size: 60),
                                onPressed: () {
                                  // Call a function to skip to the next song
                                  skipToNextSong();
                                },
                              ),
                            ],
                          ),
                        ),

                        //download
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20, top: 50, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 20, left: 15),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.download,
                                    size: 30,
                                  ),
                                ),
                              ),

                              //favourite
                              Container(
                                padding: EdgeInsets.only(right: 15),
                                //margin: EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.favorite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
