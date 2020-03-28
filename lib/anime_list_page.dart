import 'package:animist/anime_card.dart';
import 'package:animist/anime_model.dart';
import 'package:animist/drawer.dart';
import 'package:animist/page_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class AnimeListPage extends StatefulWidget {
  static String id = 'anime_list_page';
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  http.Client _client;
  dom.Document _parsedPage;

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    _parseAnimePage();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AnimistDrawer(),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xff181818),
            title: Text('ANIME LIST')),
        body: SafeArea(
            child: FutureBuilder(
          future: _getAnimeList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return GridView.builder(
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
        url: 'https://www16.gogoanime.io/anime-list.html?page=1');
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

    final listing = _parsedPage.getElementsByClassName('listing');

    // listing[0].children.forEach(
    //    (f) => print(f.children.first.attributes.values.first.trimLeft()));
    //listing[0].children.forEach((f) => print(f.children.first.text.trimLeft()));

    for (int i = 0; i < listing[0].children.length; ++i) {
      animList.add(new AnimeModel(
          name: listing[0].children[i].children.first.text.trimLeft(),
          imgUrl: null,
          animeUrl: listing[0]
              .children[i]
              .children
              .first
              .attributes
              .values
              .first
              .trimLeft()));
    }

    return animList;
  }
}
