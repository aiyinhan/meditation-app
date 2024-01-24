import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:meditation/controllers/download_controller.dart';

class MusicDownloadButton extends StatefulWidget {
  const MusicDownloadButton({Key? key, required this.musicdownloadController}) : super(key: key);
  final DownloadController musicdownloadController;

  @override
  State<MusicDownloadButton> createState() => _MusicDownloadButtonState();
}

class _MusicDownloadButtonState extends State<MusicDownloadButton> {
  late bool _showDialog;

  @override
  void initState() {
    super.initState();
    _showDialog = false;
  }

  Future<void> checkConnectivityAndDownload(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No internet connection"),
        ),
      );
    } else {
      setState(() {
        _showDialog = true;
      });

      widget.musicdownloadController.startDownload();

      // Show the progress dialog
      showProgressDialog(context);
    }
  }

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
                    widget.musicdownloadController.cancelDownload();
                    Navigator.pop(context); // Close the dialog
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
      // Check the download state after the dialog is closed
      if (widget.musicdownloadController.downloadState == DownloadState.downloaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Downloaded Successfully."),
          ),
        );
      } else if (widget.musicdownloadController.downloadState == DownloadState.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.musicdownloadController.errorMessage),
          ),
        );
      }
    });
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.musicdownloadController.downloadState == DownloadState.notDownloaded) {
          checkConnectivityAndDownload(context);
        } else if (widget.musicdownloadController.downloadState == DownloadState.downloading) {
          widget.musicdownloadController.cancelDownload();
        }
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Icon(
          _getIconForDownloadState(widget.musicdownloadController.downloadState),
          key: ValueKey<DownloadState>(widget.musicdownloadController.downloadState),
        ),
      ),
    );
  }

  IconData _getIconForDownloadState(DownloadState state) {
    switch (state) {
      case DownloadState.notDownloaded:
        return Icons.download;
      case DownloadState.downloading:
        return Icons.cancel;
      case DownloadState.downloaded:
        if (_showDialog) {
          Navigator.pop(context);
          _showDialog = false;
        }
        return Icons.done;
      case DownloadState.canceled:
        return Icons.download;
      case DownloadState.failed:
        return Icons.error;
    }
  }
}
