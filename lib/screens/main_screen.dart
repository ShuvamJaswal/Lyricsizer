import 'package:flutter/material.dart';
import 'package:lyricsizer/screens/internet/internet_search_screen.dart';
import 'package:lyricsizer/screens/local/local_main_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lyricsizer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "WELCOME",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
            ),
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "What would you like to do",
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(InternetMainScreen.routeName);
              },
              child: const Text("Search from Internet"),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                textStyle: const TextStyle(color: Colors.black12),
                backgroundColor: Colors.amberAccent,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LocalMainScreen.routeName);
              },
              child: const Text("Browse Local"),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                textStyle: const TextStyle(color: Colors.black12),
                backgroundColor: Colors.amberAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
