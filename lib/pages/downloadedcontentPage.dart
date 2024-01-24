import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation/pages/ProfilePage.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:video_player/video_player.dart';
import '../controllers/download_controller.dart';
import '../controllers/downloadVideo_controller.dart';

class DownloadedContentPage extends StatefulWidget {
  const DownloadedContentPage({Key? key}) : super(key: key);
  static String id = "DownloadContent";

  @override
  _DownloadedContentPageState createState() => _DownloadedContentPageState();
}

class _DownloadedContentPageState extends State<DownloadedContentPage> {
  bool _showMusic = true; 
  final musicListViewKey = GlobalKey<_MusicListViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              musicListViewKey.currentState?.stopMusic();
              Navigator.pushNamed(context, homePage.id);
            },
          ),
          elevation: 0,
          backgroundColor: Color(0xFF8E97FD),
          title: Text(
            _showMusic ? 'Downloaded Music' : 'Downloaded Videos',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, homePage.id);
                },
                child: Icon(
                  Icons.home,
                  color: Colors.grey[700],
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, reminderPage.id);
                },
                child: Icon(Icons.timer),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProfilePage.id);
                },
                child: Icon(Icons.person_2),
              ),
              label: '',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMusic = true; // Show music content
                      });
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _showMusic ? Colors.blue[50] : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.library_music),
                          Text('MUSIC'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMusic = false; // Show music content
                      });
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _showMusic ? Colors.white : Colors.blue[50],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.video_collection),
                          Text('VIDEO'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: _showMusic
                    ? MusicListView(key: musicListViewKey)
                    : VideoListView(), 
              ),
            ],
          ),
        ));
  }
}

class MusicListView extends StatefulWidget {
  const MusicListView({Key? key}) : super(key: key);
  @override
  State<MusicListView> createState() => _MusicListViewState();
}

class _MusicListViewState extends State<MusicListView> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Future<List<String>> downloadedSongs = getDownloadedSongs();
  int currentPlayingIndex = -1; 

  Future<void> playPauseMusic(String songPath, int index) async {
    if (isPlaying) {
      setState(() {
        isPlaying = !isPlaying;
        currentPlayingIndex = index;
      });
      await audioPlayer.pause();
    } else {
      setState(() {
        isPlaying = !isPlaying;
        currentPlayingIndex = index;
      });
      await audioPlayer.setFilePath(songPath);
      await audioPlayer.play();
    }
  }

  void stopMusic() {
    audioPlayer.stop();
    setState(() {
      isPlaying = false;
      //currentPlayingIndex = -1;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String extractSongName(String filePath) {
    List<String> pathComponents = filePath.split('/');
    String fileName = pathComponents.last; //xxx.mp3
    List<String> songName = fileName.split('.');
    return songName.first;
  }

  Future<void> deleteSong(String filePath, int index, downloadedMusic) async {
    final file = File(filePath);
    await file.delete();
    if (index >= 0 && index < downloadedMusic.length) {
      setState(() {
        downloadedMusic.removeAt(index);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getDownloadedSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final downlaodedMusic = snapshot.data;

          if (downlaodedMusic != null) {
            return ListView.separated(
              itemCount: downlaodedMusic.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (BuildContext context, int index) {
                final songPath = downlaodedMusic[index];
                final songName = extractSongName(songPath);

                if (songPath.contains('res_timestamp')) {
                  return SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          songName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          playPauseMusic(songPath, index);
                        },
                        icon: Icon(
                          currentPlayingIndex == index && isPlaying
                              ? Icons.pause_outlined
                              : Icons.play_arrow,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 34,
                        ),
                        onPressed: () {
                          deleteSong(songPath, index, downlaodedMusic);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
        return CircularProgressIndicator(); 
      },
    );
  }
}

class VideoListView extends StatefulWidget {
  const VideoListView({Key? key}) : super(key: key);

  @override
  State<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  Future<List<String>> downloadedVideo = getDownloadedVideos();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool isPlaying = false;
  int currentPlayingIndex = -1;

  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> playVideo(String videoPath, int index) async {
    if (_chewieController != null) {
      await _chewieController!.pause();
      _chewieController!.dispose();
      setState(() {
        currentPlayingIndex = -1;
      });
    }
    final videoPlayerController = VideoPlayerController.file(File(videoPath));
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
    );
    setState(() {
      currentPlayingIndex = index;
    });
    _showVideoPopup();
  }

  void _showVideoPopup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo[300],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                _chewieController?.pause();
              },
            ),
            title: Text('Video Player'),
          ),
          body: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }

  String extractVideoName(String filePath) {
    List<String> pathComponents = filePath.split('/');
    String fileName = pathComponents.last; //xxx.mp3
    List<String> videoName = fileName.split('.');
    return videoName.first;
  }

  Future<void> deleteVideo(String filePath, int index, downloadedVideos) async {
    final file = File(filePath);
    await file.delete();
    if (index >= 0 && index < downloadedVideos.length) {
      setState(() {
        downloadedVideos.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getDownloadedVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final downloadedVideos = snapshot.data;

          if (downloadedVideos != null) {
            return ListView.separated(
              itemCount: downloadedVideos.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (BuildContext context, int index) {
                final videoPath = downloadedVideos[index];
                final songName = extractVideoName(videoPath);

                if (videoPath.contains('res_timestamp')) {
                  return SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          songName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          playVideo(videoPath, index);
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 34,
                        ),
                        onPressed: () {
                          deleteVideo(videoPath, index, downloadedVideos);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }

        return CircularProgressIndicator(); // You can display a loading indicator while fetching the data.
      },
    );
  }
}
