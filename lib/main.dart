import 'package:animist/main_screen.dart';
import 'package:animist/new_season_page.dart';
import 'package:animist/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(Anime());
}

class Anime extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime',
      theme: ThemeData(
        accentColor: Color(0xff8C8C8C),
        scaffoldBackgroundColor: Color(0xff181818),
        textTheme: TextTheme()
      ),
      initialRoute: MainPage.id,
      routes: {
        MainPage.id: (context) => MainPage(),
        NewSeasonPage.id: (context) => NewSeasonPage(),
        SearchPage.id: (context) => SearchPage()
      },
    );
  }
}