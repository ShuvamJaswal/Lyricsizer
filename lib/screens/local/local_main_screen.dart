import 'package:flutter/material.dart';
import 'package:lyricsizer/providers/download_mode_provider.dart';
import 'package:lyricsizer/providers/download_provider.dart';
import 'package:lyricsizer/screens/common/song_details_screen.dart';
import 'package:lyricsizer/services/save_lyrics.dart';
import 'package:lyricsizer/services/storage_access.dart';
import 'package:lyricsizer/utils/utils.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
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

  List<SongModel> songList = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final OnAudioEdit _audioEdit = OnAudioEdit();
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
        actions: [SwitchButton()],
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
          songList = item.data!;
          return ListView.builder(
            itemCount: songList.length,
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
                    String _songId = await getSongId(songList[index].title);
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
                title: Text(songList[index].title),
                subtitle: Text(songList[index].artist ?? "No Artist"),
                trailing: ChangeNotifierProvider.value(
                    value: DownloadProvider(),
                    child: DownloadButton(songData: songList[index].getMap)),
                leading: QueryArtworkWidget(
                  nullArtworkWidget: const Icon(Icons.music_note),
                  id: songList[index].id,
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
  final Map<dynamic, dynamic> songData;
  const DownloadButton({Key? key, required this.songData}) : super(key: key);

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
    super.build(context);
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
                return context
                            .watch<DownloadModeProvider>()
                            .DownloadButtonMode ==
                        buttonMode.saveAsLrc
                    ? TextButton(
                        onPressed: () async {
                          print("pressed save as lrc");
                          value.saveAsLrc(title: widget.songData['title']);
                        },
                        child: const Text("Save as LRC"))
                    : TextButton(
                        onPressed: () async {
                          value.AddInSong(data: widget.songData);
                        },
                        child: const Text("Add in Song"));

              default:
                return const IconButton(
                    onPressed: null, icon: const Icon(Icons.save));
            }
          },
        ),
      ),
    );
  }
}

class SwitchButton extends StatelessWidget {
  const SwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: context.select<DownloadModeProvider, bool>(
            (v) => v.DownloadButtonMode == buttonMode.saveAsLrc),
        onChanged: (v) =>
            context.read<DownloadModeProvider>().changeDownloadMode());
  }
}
