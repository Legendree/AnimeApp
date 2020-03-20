import 'package:anime/anime_model.dart';
import 'package:anime/episode_card.dart';
import 'package:anime/page_parser.dart';
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    _parseAnimePage();
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
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(widget.animeModel.imgUrl,
                          width: 145, height: 237),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 6, right: 2, top: 14),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
                                  style: TextStyle(color: Colors.white54),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Divider(
                                      thickness: 1, color: Colors.white12),
                                ),
                                Text('Year: ' + 2017.toString(),
                                    style: TextStyle(color: Colors.white54))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: GridView.builder(
                      itemCount: episodeCount,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return EpsiodeCard(index: index);
                      }),
                ),
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

    final coverImage = _parsedPage.getElementsByClassName('type'); //Description

    print(coverImage[1].text);

    episodeCount = _getEpisodes()[1];
  }

  _getEpisodes() {
    var episodes = [];
    final data = _parsedPage.getElementById('episode_page');
    data.children.forEach((f) {
      episodes.add(f.firstChild.parent.text.split('\n')[1].trim().split('-'));
    });

    var firstEpisode = int.parse(episodes[0][0]);
    var lastEpisode = int.parse(episodes[episodes.length - 1]
        [episodes[episodes.length - 1].length - 1]);

    setState(() {
      isLoading = false;
    });

    return [firstEpisode, lastEpisode];
  }
}

/*
Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
                            style: TextStyle(color: Colors.white54),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )

*/