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
  List<String> downloadedSongs = [];

  DownloadController(this.songUrl, this.songName);

  CancelToken cancelToken = CancelToken();
  double downloadProgress = 0.0;
  String errorMessage = '';

  Future<void> startDownload() async {
    try {
      downloadState = DownloadState.downloading;
      final songPath = await downloadAndSaveSong(
          songUrl, songName, cancelToken);

      if (cancelToken.isCancelled) {
        downloadState = DownloadState.canceled;
        await _downloadCompleter.future;
      } else {
        downloadState = DownloadState.downloaded;
        // Add the downloaded song name to the list
        downloadedSongs.add(songName);
        print(downloadedSongs);
        _downloadCompleter.complete();
      }
    } catch (e) {
      downloadState = DownloadState.failed;
      //_downloadCompleter.completeError(e);
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


  Future<String> _getFilePath(String songName) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$songName.mp3";
  }

  Future<void> downloadAndSaveSong(String songUrl, String songName,
      CancelToken cancelToken) async {
    Dio dio = Dio();
    dio.options.headers["Range"] = "bytes=0-";
    //Response response = await dio.get(songUrl, options: Options(responseType: ResponseType.bytes));
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
          print(downloadProgress);

        },
        deleteOnError: true,
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        // Handle the download cancellation here
        return;
      } else {
        throw e;
      }
    }
  }
}
List<String> getDownloadedSongs() {
  List<String> downloadedSongs = [];
  Directory directory = Directory('/data/data/HanAiYin.meditation/app_flutter');
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