import 'dart:math';

import 'package:animist/anime_card.dart';
import 'package:animist/anime_model.dart';
import 'package:animist/drawer.dart';
import 'package:animist/page_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class MainPage extends StatefulWidget {
  static String id = 'main_screen';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex = 1;
  ScrollController _scrollController;

  List<AnimeModel> _animList = [];
  Future<List<AnimeModel>> _futureAnimeList;

  http.Client _client;
  dom.Document _parsedPage;

  Random random = new Random();

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        _parseAnimePage();
      }
    });
    _parseAnimePage();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _animList.clear();
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xff181818),
            title: Text('POPULAR')),
        drawer: AnimistDrawer(),
        body: SafeArea(
            child: FutureBuilder(
          future: _futureAnimeList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
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

  Future _parseAnimePage() async {
    final parser = new PageParser(
        url: 'https://www16.gogoanime.io/popular.html?page=' +
            pageIndex.toString());
    if (!(await parser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;
    setState(() {
      _parsedPage = parser.document();
      _futureAnimeList = _getAnimeList();
    });
    ++pageIndex;
  }

  Future<List<AnimeModel>> _getAnimeList() async {
    final names = _parsedPage.getElementsByClassName('name');
    final images = _parsedPage.getElementsByTagName('img');
    final rnd = 3 + random.nextInt(10 - 3);
    for (int i = 0; i < names.length; ++i) {
      if (i % rnd == 0) {
        _animList.add(new AnimeModel(isAd: true));
      }
      _animList.add(new AnimeModel(
          name: names[i].text,
          imgUrl: images[2 + i].attributes.values.elementAt(0),
          animeUrl: names[i].firstChild.attributes.values.elementAt(0),
          isAd: false));
    }
    return _animList;
  }
}
