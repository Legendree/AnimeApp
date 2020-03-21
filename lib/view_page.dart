import 'package:anime/ad_card.dart';
import 'package:anime/page_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:video_player/video_player.dart';

class ViewPage extends StatefulWidget {
  ViewPage({this.episodeUrl, @required this.episode});
  final String episodeUrl;
  final int episode;
  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  VideoPlayerController _controller;

  http.Client _client;
  dom.Document _parsedPage;

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    print(widget.episodeUrl);
    _parsePage();
  }

  @override
  void dispose() {
    _controller.dispose();
    print('video player killed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xff181818),
              title: Text('Episode ' + widget.episode.toString())),
      body: SafeArea(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: 16 / 9, child: VideoPlayer(_controller))
              : CircularProgressIndicator(),
          Container(
              decoration: BoxDecoration(color: Colors.white10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Please spare a moment to click this ad below, those clicks keep the app alive and updated. We don't like to force people on ads, so it is your decision to click it or not.",
                    style: TextStyle(color: Colors.white.withOpacity(0.3))),
              )),
          AdCard()
        ],
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  _parsePage() async {
    final parser = new PageParser(url: widget.episodeUrl);
    if (!(await parser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;
    setState(() {
      _parsedPage = parser.document();
    });

    final episodeLink = _parsedPage.getElementsByTagName('iframe');
    String link = episodeLink[0].attributes.values.elementAt(0).substring(2);

    final videoParser = new PageParser(url: 'http://' + link);
    if (!(await videoParser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;

    final videoLink = videoParser.document().getElementsByTagName('script');
    var vidLink = videoLink[3].text.substring(197, 700).trim();
    const start = "'";
    const end = "'";
    final startIndex = vidLink.indexOf(start);
    final endIndex = vidLink.indexOf(end, startIndex + start.length);
    final trueVideoLink =
        vidLink.substring(startIndex + start.length, endIndex);

    print(trueVideoLink);

    _controller = VideoPlayerController.network(trueVideoLink)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  _bootupAdmob() {}
}
