import 'package:anime/drawer.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static String id = 'search_page';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AnimistDrawer(),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff181818),
          title: Text('SEARCH'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],),
    );
  }
}
