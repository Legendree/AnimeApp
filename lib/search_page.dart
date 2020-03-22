import 'package:animist/drawer.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static String id = 'search_page';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = new TextEditingController();

  Icon _searchIcon;
  Widget _appBarTitle;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchIcon = new Icon(Icons.search);
    _appBarTitle = Text('SEARCH');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AnimistDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff181818),
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(icon: _searchIcon, onPressed: () => _onSearchPage())
        ],
      ),
    );
  }

  _onSearchPage() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _appBarTitle = TextField(
          maxLength: 24,
          maxLines: 1,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
            print(searchQuery);
          },
          style: TextStyle(color: Colors.white),
          controller: _filter,
          decoration: InputDecoration(
            border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.9)),
              ),
              hintStyle: TextStyle(color: Colors.white54),
              hoverColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {

                }),
              hintText: 'Search anime...'),
        );
      } else {
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text('SEARCH');
        _filter.clear();
      }
    });
  }
}
