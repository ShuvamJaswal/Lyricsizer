import 'package:flutter/material.dart';
import 'package:lyricsizer/services/save_lyrics.dart';
import 'package:lyricsizer/services/storage_access.dart';
import 'package:lyricsizer/utils/get_lyrics.dart';
import 'package:shimmer/shimmer.dart';

class LyricsScreen extends StatelessWidget {
  final String lyricsUrl;
  final String songName;
  final String artistName;
  const LyricsScreen(
      {Key? key,
      required this.lyricsUrl,
      required this.songName,
      required this.artistName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLyrics(lyricsUrl),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Lyricsizer"),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade400,
                  child: ListView.builder(
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    itemCount: 20,
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
                //     resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text("Lyricsizer"),
                ),
                body: const Center(child: Text("Something went wrong")));
          }
          return Scaffold(
            //     resizeToAvoidBottomInset: false,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      try {
                        await saveLyricsAsLrc(
                            fileName: "$songName - $artistName.lrc",
                            Lyrics: snapshot.data.toString());
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(40))),
                            backgroundColor: Colors.cyanAccent.shade400,
                            content: const Text(
                                "Lyrics Saved in Music/Lyrics folder")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            shape: const RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40))),
                            backgroundColor: Colors.cyanAccent.shade400,
                            content: const Text("Something Went Wrong")));
                      }
                    },
                    icon: const Icon(Icons.save))
              ],
              automaticallyImplyLeading: false,
              title: const Text("Lyricsizer"),
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                child: Text(
                  snapshot.data.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        });
  }
}
