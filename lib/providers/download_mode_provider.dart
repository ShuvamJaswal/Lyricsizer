import 'package:flutter/material.dart';

enum buttonMode { saveAsLrc, embedInSong }

class DownloadModeProvider with ChangeNotifier {
  var DownloadButtonMode = buttonMode.saveAsLrc;
  void changeDownloadMode() {
    DownloadButtonMode = DownloadButtonMode == buttonMode.saveAsLrc
        ? buttonMode.embedInSong
        : buttonMode.saveAsLrc;
    notifyListeners();
  }
}
