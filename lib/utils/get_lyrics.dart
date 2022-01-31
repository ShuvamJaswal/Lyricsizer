import 'package:html/parser.dart';

import 'package:dio/dio.dart';

Future<String> getLyrics(String pageUrl) async {
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
