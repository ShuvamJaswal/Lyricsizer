import 'package:flutter/material.dart';
import 'package:lyricsizer/providers/search_provider.dart';
import 'package:lyricsizer/screens/common/song_details_screen.dart';
import 'package:lyricsizer/widgets/network_image.dart';
import 'package:provider/provider.dart';

class InternetMainScreen extends StatefulWidget {
  const InternetMainScreen({Key? key}) : super(key: key);
  static const routeName = 'internet-main-screen';
  @override
  _InternetMainScreenState createState() => _InternetMainScreenState();
}

class _InternetMainScreenState extends State<InternetMainScreen> {
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
          child: Column(
            children: [
              SearchFieldInput(),
              const Expanded(child: SearchResultsView())
            ],
          ),
        ));
  }
}

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return Consumer<SearchProvider>(builder: (context, value, child) {
      switch (value.status) {
        case requestState.empty:
          return const Center(
            child: Text("Enter Something to search"),
          );

        case requestState.isFetching:
          return const Center(child: CircularProgressIndicator());

        case requestState.noResult:
          return const Center(
            child: Text(
              "No result",
            ),
          );
        case requestState.error:
          return const Center(child: Text("Something Went Wrong"));

        case requestState.done:
          return ListView.builder(
            itemCount: value.results.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SongDetailsScreen(
                      key: key, songId: searchProvider.results[index].songId),
                ));
              },
              title: Text(searchProvider.results[index].name),
              leading: CircleAvatar(
                  child: NetworkImageFromUrl(
                      isIcon: true,
                      imageUrl: searchProvider.results[index].imageUrl)),
            ),
          );

        default:
          return const Center(
            child: Text("Enter Something to search"),
          );
      }
    });
  }
}

// ignore: must_be_immutable
class SearchFieldInput extends StatelessWidget {
  SearchFieldInput({Key? key}) : super(key: key);
  String lastInput = "";
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return TextField(
      onChanged: (text) {
        if (lastInput != text) {
          searchProvider.makeSearchQuery(text);
        }
        lastInput = text;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        labelText: "Enter Term to search.",
      ),
    );
  }
}
