import 'package:flutter/material.dart';
import 'package:lyricsizer/services/save_lyrics.dart';
import 'package:lyricsizer/utils/utils.dart';
import 'package:on_audio_edit/on_audio_edit.dart';

enum requestState { initial, isFetching, done, error, noResult }

class DownloadProvider with ChangeNotifier {
  var status = requestState.initial;
  final OnAudioEdit _audioEdit = OnAudioEdit();
  Future<void> AddInSong({required Map<dynamic, dynamic> data}) async {
    Map<TagType, dynamic> tags = {};

    status = requestState.isFetching;
    notifyListeners();
    try {
      await getLyricsFromTitle(data['title']).then((value) {
        tags = {
          TagType.LYRICS: value.toString(),
        };
      });
      await _audioEdit.editAudio(data['_data'], tags,
          searchInsideFolders: true);
      status = requestState.done;
      notifyListeners();
    } catch (e) {
      print(e);
      status = requestState.error;
      notifyListeners();
    }
  }

  Future<void> saveAsLrc({required String title}) async {
    status = requestState.isFetching;
    notifyListeners();
    try {
      await saveLyricsAsLrc(
          lyrics: await getLyricsFromTitle(title), fileName: title);
      status = requestState.done;
      notifyListeners();
    } catch (e) {
      print(e);
      status = requestState.error;
      notifyListeners();
    }
  }
}
