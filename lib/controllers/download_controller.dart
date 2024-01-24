import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum DownloadState { notDownloaded, downloading, downloaded, canceled, failed }

class DownloadController extends ChangeNotifier {
  final String songUrl;
  final String songName;
  DownloadState downloadState = DownloadState.notDownloaded;
  final Completer<void> _downloadCompleter = Completer<void>();
  List<String> downloadedSongs = [];

  DownloadController(this.songUrl, this.songName);

  CancelToken cancelToken = CancelToken();
  double downloadProgress = 0.0;
  String errorMessage = '';

  Future<void> startDownload() async {
    try {
      downloadState = DownloadState.downloading;
      cancelToken = CancelToken();

      final songPath =
          await downloadAndSaveSong(songUrl, songName, cancelToken);

      if (cancelToken.isCancelled) {
        downloadState =
            DownloadState.notDownloaded; //from cancelled to notDownloaded
        await _downloadCompleter.future;
      } else {
        downloadState = DownloadState.downloaded;
        downloadedSongs.add(songName);
        _downloadCompleter.complete();
      }
    } catch (e) {
      downloadState = DownloadState.failed;
      errorMessage = 'Download failed: $e';
    }
  }

  Future<void> cancelDownload() async {
    if (downloadState == DownloadState.downloading) {
      cancelToken.cancel("Download canceled");
      downloadState = DownloadState.canceled;
      print('Song download canceled');
      await _downloadCompleter.future;
    }
    downloadState = DownloadState.notDownloaded;
  }

  Future<String> _getMusicDirectoryPath() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("uid$uid");
    final dir = await getApplicationDocumentsDirectory();
    print("uid$dir");
    return "${dir.path}/music/$uid";
  }

  Future<String> _getFilePath(String songName) async {
    final dir = await _getMusicDirectoryPath(); // Get the video directory
    return "$dir/$songName.mp4";
  }

  Future<void> downloadAndSaveSong(
      String songUrl, String songName, CancelToken cancelToken) async {
    Dio dio = Dio();
    dio.options.headers["Range"] = "bytes=0-";
    String path = await _getFilePath(songName);
    Response response;
    try {
      response = await dio.download(
        songUrl,
        path,
        cancelToken: cancelToken, // Pass the cancelToken to the request
        onReceiveProgress: (receivedBytes, totalBytes) {
          downloadProgress = receivedBytes / totalBytes;
          notifyListeners();
          if ((downloadProgress * 100).toInt() % 10 == 0) {
            print((downloadProgress * 100).toInt().toString());
          }
        },
        deleteOnError: true,
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        return;
      } else {
        throw e;
      }
    }
  }
}

Future<List<String>> getDownloadedSongs() async {
  final dir = await getApplicationDocumentsDirectory();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> downloadedSongs = [];
  Directory directory = Directory('${dir.path}/music/$uid');
  if (directory.existsSync()) {
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        downloadedSongs.add(file.path);
      }
    }
  }
  return downloadedSongs;
} //}