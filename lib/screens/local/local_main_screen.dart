import 'package:flutter/material.dart';

class LocalMainScreen extends StatefulWidget {
  const LocalMainScreen({Key? key}) : super(key: key);
  static const routeName = 'local-main-screen';

  @override
  _LocalMainScreenState createState() => _LocalMainScreenState();
}

class _LocalMainScreenState extends State<LocalMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Lyricsizer"),
      ),
      body: const Text("TODO"),
    );
  }
}
