import 'package:animist/anime_model.dart';
import 'package:animist/episode_card.dart';
import 'package:animist/page_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AnimePage extends StatefulWidget {
  AnimePage({this.animeModel});
  final AnimeModel animeModel;
  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  http.Client _client;
  dom.Document _parsedPage;

  int episodeCount = 0;
  String animeDescription = '';
  String releaseDate = '';
  String genre = '';
  String urlForEpisode = '';

  bool isLoading = true;

  Widget _widgetToShow;

  @override
  void initState() {
    super.initState();
    _widgetToShow = SizedBox();
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
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xff181818),
              title: Text(widget.animeModel.name)),
          body: SafeArea(
              child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max, //145 237
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.animeModel.imgUrl != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Image.network(widget.animeModel.imgUrl,
                                  width: 145, height: 210, fit: BoxFit.fill),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Image.asset('images/img_block.png',
                                  width: 145, height: 210, fit: BoxFit.fill),
                            ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 6, right: 2, top: 14),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 1.0, bottom: 8.0),
                            child: Container(
                              height: 204,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      animeDescription,
                                      style: TextStyle(color: Colors.white54),
                                      textAlign: TextAlign.left,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Divider(
                                          thickness: 1, color: Colors.white12),
                                    ),
                                    Text(releaseDate,
                                        style:
                                            TextStyle(color: Colors.white54)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Divider(
                                          thickness: 1, color: Colors.white12),
                                    ),
                                    Text('Genre: ' + genre,
                                        style: TextStyle(color: Colors.white54))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                episodeCount != 0
                    ? Flexible(
                        child: GridView.builder(
                            itemCount: episodeCount,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return EpisodeCard(
                                  index: index + 1, url: urlForEpisode);
                            }),
                      )
                    : _widgetToShow,
              ],
            ),
          ))),
    );
  }

  Future<void> _parseAnimePage() async {
    final parser = new PageParser(
        url: 'https://www16.gogoanime.io' + widget.animeModel.animeUrl);
    if (!(await parser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;
    setState(() {
      _parsedPage = parser.document();
    });

    final description =
        _parsedPage.getElementsByClassName('type'); //Description
    animeDescription = description[1].text.substring(14);
    releaseDate = description[3].text;
    genre = description[2].text.split('\n')[1].trim();

    urlForEpisode = widget.animeModel.animeUrl.substring(10);
    urlForEpisode += '-episode-';

    episodeCount = _getEpisodes()[1];

    if (episodeCount == 0) {
      _widgetToShow = Flexible(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.query_builder, color: Colors.white30, size: 50),
              SizedBox(height: 15),
              Text('No episodes released yet.\nPlease come back later :)',
                  style: TextStyle(color: Colors.white30)),
            ],
          ),
        ),
      );
    }
  }

  _getEpisodes() {
    var episodes = [];
    final data = _parsedPage.getElementById('episode_page');
    data.children.forEach((f) {
      episodes.add(f.firstChild.parent.text.split('\n')[1].trim().split('-'));
    });

    //var firstEpisode = int.parse(episodes[0][0]);
    var lastEpisode = int.parse(episodes[episodes.length - 1]
        [episodes[episodes.length - 1].length - 1]);

    setState(() {
      isLoading = false;
    });

    print([1, lastEpisode]);

    return [1, lastEpisode];
  }
}
