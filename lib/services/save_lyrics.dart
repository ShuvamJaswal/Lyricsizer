import 'dart:io';

import 'package:lyricsizer/services/storage_access.dart';

Future<void> saveLyricsAsLrc(
    {required String fileName, required String Lyrics}) async {
  try {
    StorageAccess().getMusicLyricsDirectory().then((value) {
      File('$value/$fileName')
          .create(recursive: true)
          .then((value) => value.writeAsString(Lyrics));
    });
  } catch (e) {
    rethrow;
  }
}
