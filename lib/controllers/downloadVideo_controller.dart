import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

enum VideoDownloadState { notDownloaded, downloading, downloaded, failed }

class VideoDownloadController {
  final String videoUrl;
  final String videoName;
  VideoDownloadState downloadState = VideoDownloadState.notDownloaded;
  final Completer<void> _downloadCompleter = Completer<void>();
  CancelToken cancelToken = CancelToken();
  String errorMessage = " ";
  VideoDownloadController(this.videoUrl, this.videoName);

  Future<void> startVideoDownload() async {
    try {
      downloadState = VideoDownloadState.downloading;
      cancelToken = CancelToken();
      await downloadAndSaveVideo(videoUrl, videoName, cancelToken);

      if (cancelToken.isCancelled) {
        downloadState = VideoDownloadState.notDownloaded;
        await _downloadCompleter.future;
      } else {
        downloadState = VideoDownloadState.downloaded;
        _downloadCompleter.complete();
      }
    } catch (e) {
      downloadState = VideoDownloadState.failed;
      _downloadCompleter.completeError(e);
      errorMessage = 'Download failed: $e';
    }
  }

  Future<void> cancelVideoDownload() async {
    if (downloadState == VideoDownloadState.downloading) {
      cancelToken.cancel("Download canceled");
      downloadState =
          VideoDownloadState.notDownloaded; //cancel change to not downloaded
      await _downloadCompleter.future;
    }
    downloadState = VideoDownloadState.notDownloaded;
  }

  Future<String> _getVideoDirectoryPath() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("uid$uid");
    final dir = await getApplicationDocumentsDirectory();
    print("uid$dir");
    return "${dir.path}/videos/$uid";
  }

  Future<String> _getVideoFilePath(String videoName) async {
    final dir = await _getVideoDirectoryPath(); // Get the video directory
    return "$dir/$videoName.mp4";
  }

  Future<void> downloadAndSaveVideo(
      String videoUrl, String videoName, CancelToken cancelToken) async {
    Dio dio = Dio();
    dio.options.headers["Range"] = "bytes=0-";
    double downloadProgress = 0.0;
    final path = await _getVideoFilePath(videoName);
    Response response;
    try {
      response = await dio.download(
        videoUrl,
        path,
        cancelToken: cancelToken, // Pass the cancelToken to the request
        onReceiveProgress: (receivedBytes, totalBytes) {
          downloadProgress = receivedBytes / totalBytes;
          if ((downloadProgress * 100).toInt() % 10 == 0) {
            print((downloadProgress * 100).toInt().toString());
          }
        },
        deleteOnError: true,
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        // Handle the download cancellation here
        return;
      } else {
        print(e);
      }
    }
  }
}

Future<List<String>> getDownloadedVideos() async {
  final dir = await getApplicationDocumentsDirectory();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> downloadedVideos = [];
  Directory directory = Directory("${dir.path}/videos/$uid");
  if (directory.existsSync()) {
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        downloadedVideos.add(file.path);
      }
    }
  }
  return downloadedVideos;
}
