import 'package:flutter/material.dart';
import 'package:lyricsizer/services/save_lyrics.dart';
import 'package:lyricsizer/utils/utils.dart';

enum requestState { initial, isFetching, done, error, noResult }

class DownloadProvider with ChangeNotifier {
  var status = requestState.initial;
  Future<void> saveAsLrc({required String title}) async {
    status = requestState.isFetching;
    notifyListeners();
    try {
      await saveLyricsAsLrc(
          lyrics: await getLyricsFromTitle(title), fileName: title);
      status = requestState.done;
      notifyListeners();
    } catch (e) {
      status = requestState.error;
      notifyListeners();
    }
  }
}
