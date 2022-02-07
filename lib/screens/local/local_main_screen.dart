import 'package:flutter/material.dart';
import 'package:lyricsizer/providers/download_provider.dart';
import 'package:lyricsizer/screens/common/song_details_screen.dart';
import 'package:lyricsizer/services/save_lyrics.dart';
import 'package:lyricsizer/services/storage_access.dart';
import 'package:lyricsizer/utils/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class LocalMainScreen extends StatefulWidget {
  const LocalMainScreen({Key? key}) : super(key: key);
  static const routeName = 'local-main-screen';

  @override
  _LocalMainScreenState createState() => _LocalMainScreenState();
}

class _LocalMainScreenState extends State<LocalMainScreen> {
  Future<List> getAllSongs() async {
    List songs = await _audioQuery.querySongs();
    return songs;
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();
    getPermission();
  }

  getPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
      await StorageAccess().checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Lyricsizer"),
      ),
      body: FutureBuilder<List<SongModel>>(
        // Default values:
        future: _audioQuery.querySongs(
            uriType: UriType.EXTERNAL, path: '/storage/emulated/0/Music'),
        builder: (context, item) {
          // Loading content
          if (item.data == null) return const CircularProgressIndicator();

          // When you try "query" without asking for [READ] or [Library] permission
          // the plugin will return a [Empty] list.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          // You can use [item.data!] direct or you can create a:
          // List<SongModel> songs = item.data!;

          return ListView.builder(
            itemCount: item.data!.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () async {
                  try {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()));
                    String _songId = await getSongId(item.data![index].title);
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SongDetailsScreen(
                          songId: _songId,
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Something went wrong",
                        ),
                      ),
                    );
                  }
                },
                title: Text(item.data![index].title),
                subtitle: Text(item.data![index].artist ?? "No Artist"),
                trailing: ChangeNotifierProvider.value(
                    value: DownloadProvider(),
                    child: DownloadButton(title: item.data![index].title)),
                leading: QueryArtworkWidget(
                  nullArtworkWidget: const Icon(Icons.music_note),
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DownloadButton extends StatefulWidget {
  final String title;
  const DownloadButton({Key? key, required this.title}) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton>
    with AutomaticKeepAliveClientMixin {
  //used in widget which needs to stay alive while scrolling in listview builder
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return GestureDetector(
      child: Consumer<DownloadProvider>(
        builder: (context, value, child) => Builder(
          builder: (context) {
            switch (value.status) {
              case requestState.error:
                return IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              case requestState.done:
                return IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    ));
              case requestState.isFetching:
                return const CircularProgressIndicator();
              case requestState.initial:
                return IconButton(
                    onPressed: () async {
                      value.saveAsLrc(title: widget.title);
                    },
                    icon: const Icon(Icons.save));

              default:
                return const IconButton(
                    onPressed: null, icon: const Icon(Icons.save));
            }

            const Text("");
          },
        ),
      ),
    );
  }
}
