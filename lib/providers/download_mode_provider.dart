import 'package:flutter/material.dart';

enum buttonMode { saveAsLrc, embedInSong }

class DownloadModeProvider with ChangeNotifier {
  var downloadButtonMode = buttonMode.saveAsLrc;
  void changeDownloadMode() {
    downloadButtonMode = downloadButtonMode == buttonMode.saveAsLrc
        ? buttonMode.embedInSong
        : buttonMode.saveAsLrc;
    notifyListeners();
  }
}
