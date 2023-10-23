import 'package:flutter/material.dart';
import 'package:meditation/controllers/download_controller.dart';
import 'package:provider/provider.dart';
import 'package:meditation/models/song_model.dart';

class downloadVideo extends StatelessWidget {
  const downloadVideo({Key? key}) : super(key: key);
  static String id ='downloadVideo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Songs'),
      ),
      body: Consumer<DownloadController>(
        builder: (context, DownloadController, _) {
          final downloadedSongs = DownloadController.downloadedSongs;
          print('Downloaded Songs Count: ${downloadedSongs.length}');
          print('Downloaded Songs: $downloadedSongs');
          return ListView.builder(
            itemCount: downloadedSongs.length,
            itemBuilder: (context, index) {
              // Song song = downloadedSongs[index];
              // return ListTile(
              //   title: Text(song.title),
              //   subtitle: Text(song.artist),
              //   onTap: () {
              //     // Play the downloaded song when tapped
              //   //  DownloadController.(song.url);
              //   },
              //);
            },
          );
        },
      ),
    );
  }
}