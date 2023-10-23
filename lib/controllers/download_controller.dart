import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';


enum DownloadState { notDownloaded, downloading, downloaded, canceled, failed }


class DownloadController extends ChangeNotifier {
  final String songUrl;
  final String songName;
  DownloadState downloadState = DownloadState.notDownloaded;
  final Completer<void> _downloadCompleter = Completer<void>();
  List<String> downloadedSongs=[];
  DownloadController(this.songUrl, this.songName);

  Future<void> startDownload() async {
    try {
      downloadState = DownloadState.downloading;
      final songPath = await downloadAndSaveSong(songUrl, songName);
      // if (downloadState == DownloadState.canceled) {
      //   await deleteDownloadedSong(songPath);
      // }
      downloadState = DownloadState.downloaded;
      // Add the downloaded song name to the list
      downloadedSongs.add(songName);
      print(downloadedSongs);
      _downloadCompleter.complete();
    } catch (e) {
      downloadState = DownloadState.failed;
      _downloadCompleter.completeError(e);
    }
  }

  Future<void> cancelDownload() async {
    if (downloadState == DownloadState.downloading) {
      downloadState = DownloadState.canceled;
      await _downloadCompleter.future;
    }
  }
}

Future<String> _getFilePath(String songName) async {
  final dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/$songName.mp3";
}

Future<void> downloadAndSaveSong(String songUrl, String songName) async {
  Dio dio = Dio();
  double downloadProgress = 0.0;
  //Response response = await dio.get(songUrl, options: Options(responseType: ResponseType.bytes));
  String path = await _getFilePath(songName);
  await dio.download(
    songUrl,
    path,
    onReceiveProgress: (recivedBytes, totalBytes) {
      downloadProgress = recivedBytes / totalBytes;
      print(downloadProgress);
    },
    deleteOnError: true,
  );
}


Future<void> deleteDownloadedSong(String songPath) async {
  final songFile = File(songPath);
  if (songFile.existsSync()) {
    await songFile.delete();
  }
}