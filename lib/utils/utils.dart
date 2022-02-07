import 'package:html/parser.dart';

import 'package:dio/dio.dart';
import 'package:lyricsizer/models/song_details_model.dart';

Future<String> getLyricsFromTitle(String title) async {
  return getSongDataFromId(await getSongId(title)).then((songModel) {
    return songModel.lyricsURL;
  }).then((lyricsUrl) {
    return getLyricsFromUrl(lyricsUrl);
  });
}

Future<String> getSongId(String name) {
  return Dio().get(
    'https://genius.com/api/search/song',
    queryParameters: {'q': name.trim()},
  ).then((value) => (value.data['response']['sections'][0]['hits'][0]['result']
          ['id']
      .toString()));
}

Future<String> getLyricsFromUrl(String pageUrl) async {
  return await Dio()
      .get(pageUrl)
      .then((value) => value.data.toString().replaceAll('<br/>', '\n'))
      .then((value) {
    return (parse(value))
        .querySelectorAll("[class*='Lyrics__Root'],div.lyrics")[0]
        .text
        .trim();
  });
}

Future<SongDetailsModel> getSongDataFromId(String songId) async {
  return await Dio().get("https://genius.com/api/songs/$songId} ").then(
    (value) {
      return SongDetailsModel.fromJSON(
          value.data['response']['song'] as Map<String, dynamic>);
    },
  );
}
