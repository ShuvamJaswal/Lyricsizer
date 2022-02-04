import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageAccess {
  Future<bool> checkPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      return Permission.storage.request().then((storage) {
        return storage.isGranted;
      });
    }
  }

  Future<String> getMusicLyricsDirectory() async {
    Directory? directory;
    try {
      if (await checkPermission()) {
        directory = await getExternalStorageDirectory();

        directory = Directory(directory!.path.replaceFirst(
            'Android/data/com.thebeastapplications.lyricsizer/files',
            'Music/Lyrics/'));
        if (!(await directory.exists())) {
          await directory.create(recursive: true);
        }
      }
      return directory!.path;
    } catch (e) {
      rethrow;
    }
  }
}
