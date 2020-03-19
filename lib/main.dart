import 'package:anime/main_screen.dart';
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
      title: 'Anime',
      theme: ThemeData(
        accentColor: Color(0xffffffff),
        scaffoldBackgroundColor: Color(0xff181818),
        textTheme: TextTheme()
      ),
      home: MainPage(),
    );
  }
}