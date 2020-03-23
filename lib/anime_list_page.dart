import 'package:animist/drawer.dart';
import 'package:flutter/material.dart';

class AnimeListPage extends StatefulWidget {
  static String id = 'anime_list_page';
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AnimistDrawer(),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xff181818),
            title: Text('ANIME LIST')),
        body: SafeArea(
            child: Center(
                child: Text('This page is not available yet.',
                    style: TextStyle(color: Colors.white30),
                    textAlign: TextAlign.center))));
  }
}