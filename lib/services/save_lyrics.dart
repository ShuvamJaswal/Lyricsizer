import 'dart:io';

import 'package:lyricsizer/services/storage_access.dart';

Future<void> saveLyricsAsLrc(
    {required String fileName, required String lyrics}) async {
  try {
    StorageAccess().getMusicLyricsDirectory().then((value) {
      File('$value$fileName.lrc')
          .create(recursive: true)
          .then((value) => value.writeAsString(lyrics));
    });
  } catch (e) {
    rethrow;
  }
}
