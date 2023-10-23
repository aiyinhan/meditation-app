import 'package:flutter/material.dart';
import 'package:meditation/controllers/download_controller.dart';

class CustomDownloadButton extends StatelessWidget {
  final DownloadController downloadController;

  CustomDownloadButton({required this.downloadController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (downloadController.downloadState == DownloadState.notDownloaded) {
          downloadController.startDownload();
        } else if (downloadController.downloadState == DownloadState.downloading) {
          downloadController.cancelDownload();
        }
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Icon(
          _getIconForDownloadState(downloadController.downloadState),
          key: ValueKey<DownloadState>(downloadController.downloadState),
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
        return Icons.done;
      case DownloadState.canceled:
        return Icons.cancel;
      case DownloadState.failed:
        return Icons.error;
    }
  }
}