import 'dart:math';

import 'package:animist/anime_card.dart';
import 'package:animist/anime_model.dart';
import 'package:animist/drawer.dart';
import 'package:animist/page_parser.dart';
import 'package:animist/statics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class SearchPage extends StatefulWidget {
  static String id = 'search_page';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  http.Client _client;
  dom.Document _parsedPage;

  final TextEditingController _filter = new TextEditingController();
  ScrollController _scrollController;

  Icon _searchIcon;
  Widget _appBarTitle;

  String searchQuery = '';

  Random random = new Random();

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    _searchIcon = Icon(Icons.search);
    _appBarTitle = Text('SEARCH');
  }

  @override
  void dispose() {
    if (_client != null) _client.close();
    super.dispose();
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
        body: SafeArea(
            child: FutureBuilder(
          future: _getAnimeList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/mob.png', width: 242, height: 219),
                  SizedBox(height: 25),
                  Text(
                    'Type the name of the anime you want to watch\nand hit the search icon',
                    style: TextStyle(color: Colors.white24),
                    textAlign: TextAlign.center,
                  ),
                ],
              ));
            }
            if (snapshot.hasData) {
              _scrollController = new ScrollController();
              return GridView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: AnimeCard(animeModel: snapshot.data[index]),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )));
  }

  Future _parseSearch(String query) async {
    final parser = new PageParser(
        url: 'https://www16.gogoanime.io/search.html?keyword=' + query);
    if (!(await parser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;
    setState(() {
      _parsedPage = parser.document();
    });
  }

  Future<List<AnimeModel>> _getAnimeList() async {
    List<AnimeModel> animList = [];

    final names = _parsedPage.getElementsByClassName('name');
    final images = _parsedPage.getElementsByTagName('img');
    final rnd = Statics.min + random.nextInt(Statics.max - Statics.min);
    for (int i = 0; i < names.length; ++i) {
      if (i % rnd == 0) {
        animList.add(new AnimeModel(isAd: true));
      }
      animList.add(new AnimeModel(
          name: names[i].text,
          imgUrl: images[2 + i].attributes.values.elementAt(0),
          animeUrl: names[i].firstChild.attributes.values.elementAt(0),
          isAd: false));
    }
    return animList;
  }

  _onSearchPage() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _appBarTitle = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            keyboardType: TextInputType.text,
            maxLength: 24,
            maxLines: 1,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
              print(searchQuery);
            },
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                decoration: TextDecoration.none),
            controller: _filter,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white54),
                hoverColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      if (_scrollController != null)
                        _scrollController.jumpTo(0);
                      _parseSearch(searchQuery);
                    }),
                hintText: 'Search anime...'),
          ),
        );
      } else {
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text('SEARCH');
        _filter.clear();
      }
    });
  }
}
