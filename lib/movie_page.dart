import 'package:animist/anime_card.dart';
import 'package:animist/anime_model.dart';
import 'package:animist/drawer.dart';
import 'package:animist/page_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class MoviePage extends StatefulWidget {
  static String id = 'movie_page';
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  http.Client _client;
  dom.Document _parsedPage;

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    _parseMoviePage();
  }

  @override
  void dispose() {
    if(_client != null)
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
            title: Text('MOVIES')),
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

  Future _parseMoviePage() async {
    final parser =
        new PageParser(url: 'https://www4.gogoanimehub.tv/anime-movies.html');
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

    for (int i = 0; i < names.length; ++i) {
      animList.add(new AnimeModel(
          name: names[i].text,
          imgUrl: images[2 + i].attributes.values.elementAt(0),
          animeUrl: names[i].firstChild.attributes.values.elementAt(0)));
    }
    return animList;
  }
}
