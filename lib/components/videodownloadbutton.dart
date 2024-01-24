import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:meditation/controllers/downloadVideo_controller.dart';

class VideoDownloadButton extends StatefulWidget {
  const VideoDownloadButton({Key? key, required this.videodownloadController})
      : super(key: key);
  final VideoDownloadController videodownloadController;
  @override
  State<VideoDownloadButton> createState() => _VideoDownloadButtonState();
}

class _VideoDownloadButtonState extends State<VideoDownloadButton> {

  Widget showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.black54,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Downloading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.videodownloadController.cancelVideoDownload();
                    Navigator.pop(context);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                  ),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (widget.videodownloadController.downloadState ==
          VideoDownloadState.downloaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Downloaded Successfully."),
          ),
        );
      } else if (widget.videodownloadController.downloadState ==
          VideoDownloadState.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.videodownloadController.errorMessage),
          ),
        );
      }
    });
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showProgressDialog(context);
        await widget.videodownloadController.startVideoDownload();
        setState(() {
          Navigator.pop(context);
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Icon(
          _getIconForDownloadState(
              widget.videodownloadController.downloadState),
          key: ValueKey<VideoDownloadState>(
              widget.videodownloadController.downloadState),
        ),
      ),
    );
  }

  IconData _getIconForDownloadState(VideoDownloadState state) {
    switch (state) {
      case VideoDownloadState.notDownloaded:
        return Icons.download;
      case VideoDownloadState.downloading:
        return Icons.cancel;
      case VideoDownloadState.downloaded:
        return Icons.done;
      case VideoDownloadState.failed:
        return Icons.error;
    }
  }
}
