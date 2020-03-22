import 'package:animist/drawer.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  static String id = 'movie_page';
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AnimistDrawer(),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff181818),
          title: Text('MOVIES')),
    );
  }
}
