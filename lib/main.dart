import 'package:flutter/material.dart';
import 'package:lyricsizer/providers/download_mode_provider.dart';
import 'package:lyricsizer/providers/search_provider.dart';
import 'package:lyricsizer/screens/internet/internet_search_screen.dart';
import 'package:lyricsizer/screens/local/local_main_screen.dart';
import 'package:lyricsizer/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DownloadModeProvider>(
              create: (_) => DownloadModeProvider()),
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Lyricsizer',
          theme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            scaffoldBackgroundColor: Colors.black,
          ),
          home: const MainScreen(),
          routes: {
            LocalMainScreen.routeName: (ctx) => const LocalMainScreen(),
            InternetMainScreen.routeName: (ctx) => const InternetMainScreen(),
          },
        ));
  }
}
