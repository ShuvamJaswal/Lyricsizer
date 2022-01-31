import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:lyricsizer/models/song_details_model.dart';
import 'package:lyricsizer/screens/common/lyrics_screen.dart';
import 'package:lyricsizer/widgets/network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SongDetailsScreen extends StatefulWidget {
  final String songId;
  const SongDetailsScreen(
    Key? key,
    this.songId,
  ) : super(key: key);
  @override
  _SongDetailsScreenState createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  Future<SongDetailsModel> _getSongData() async {
    return await Dio()
        .get("https://genius.com/api/songs/${widget.songId}")
        .then(
      (value) {
        return SongDetailsModel.fromJSON(
            value.data['response']['song'] as Map<String, dynamic>);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Lyricsizer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<SongDetailsModel>(
          future: _getSongData(),
          builder: (context, snapshot) {
            //  if (!snapshot.hasData) return CircularProgressIndicator();
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            return SongDetailsBody(data: snapshot.data);
            //NetworkImageFromUrl(imageUrl: snapshot.data!.imageUrl ?//? "");
          },
        ),
      ),
    );
  }
}

class SongDetailsBody extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const SongDetailsBody({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data.soundCloudUrl);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                //  clipBehavior: Clip.antiAlias,
                child: NetworkImageFromUrl(
                  imageUrl: data.imageUrl ?? "",
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Title: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text("${data.name}",
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 0, 5),
            child: Row(
              children: [
                Text("Artist: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "${data.artist}",
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Release Date: ${data.releaseDate}"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (data.youTubeUrl != null)
                IconButton(
                  icon: const Icon(
                    MdiIcons.youtube,
                    size: 40,
                    color: Colors.red,
                  ),
                  onPressed: () => launch(data.youTubeUrl),
                ),
              if (data.spotifyUrl != null)
                IconButton(
                  icon: const Icon(
                    MdiIcons.spotify,
                    size: 40,
                    color: Colors.green,
                  ),
                  onPressed: () => launch(data.spotifyUrl),
                ),
              if (data.soundCloudUrl != null)
                IconButton(
                  icon: const Icon(
                    MdiIcons.soundcloud,
                    size: 40,
                    color: Colors.orange,
                  ),
                  onPressed: () => launch(data.soundCloudUrl),
                ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(color: Colors.black12),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LyricsScreen(lyricsUrl: data.lyricsURL)));
            },
            child: const Text(
              "LYRICS",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
