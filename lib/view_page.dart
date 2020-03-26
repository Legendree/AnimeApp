import 'package:animist/ad_card.dart';
import 'package:animist/page_parser.dart';
import 'package:chewie2/chewie2.dart';
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
  ChewieController _chewieController;

  http.Client _client;
  dom.Document _parsedPage;

  Future videoLink;

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    print(widget.episodeUrl);
    setState(() {
      videoLink = _parsePage();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    _client.close();
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
          FutureBuilder(
            future: videoLink,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _controller = VideoPlayerController.network(snapshot.data);
                _chewieController = ChewieController(
                    cupertinoProgressColors: ChewieProgressColors(
                        backgroundColor: Colors.black,
                        bufferedColor: Colors.black54),
                    materialProgressColors: ChewieProgressColors(
                        backgroundColor: Colors.black,
                        handleColor: Colors.black),
                    videoPlayerController: _controller,
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    looping: false);
                return Chewie(
                  controller: _chewieController,
                );
              } else if (snapshot.hasError) {
                return Container(
                    height: 200,
                    child: Center(
                      child: Icon(Icons.error_outline),
                    ));
              } else {
                return Container(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ));
              }
            },
          ),
          Container(
              decoration: BoxDecoration(color: Colors.white10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    //Please spare a moment to click this ad below, those clicks keep the app alive and updated. We don't like to force people on ads, so it is your decision to click it or not.
                    children: <TextSpan>[
                      TextSpan(text: 'Please spare a moment to click this ad below, those ', style: TextStyle(color: Colors.white.withOpacity(0.3))),
                      TextSpan(text: 'ad clicks keep the app alive and updated.', style: TextStyle(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.bold)),
                      TextSpan(text: " We don't like to force people on ads, so it is your decision to click it or not.", style: TextStyle(color: Colors.white.withOpacity(0.3)))
                    ]
                  )
                ),
              )),
          AdCard()
        ],
      ))),
    );
  }

  Future _parsePage() async {
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

/*
    print('--------------------------------------------------------------');
    print(link.replaceFirst('streaming', 'load', 16));
    print('--------------------------------------------------------------');

    print(link);
*/
    final videoParser = new PageParser(url: 'http://' + link);

    if (!(await videoParser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;

    final videoLink = videoParser.document().getElementsByTagName('script');
    var vidLink = videoLink[3].text.substring(197, 700).trim();
    //print(videoLink[3].text);
    const start = "'";
    const end = "'";
    final startIndex = vidLink.indexOf(start);
    final endIndex = vidLink.indexOf(end, startIndex + start.length);
    var trueVideoLink = vidLink.substring(startIndex + start.length, endIndex);

/*
    print('--------------------------------------------------------------');
    print(trueVideoLink.substring(
        trueVideoLink.length - 4, trueVideoLink.length));
    print('--------------------------------------------------------------');
*/
    if (trueVideoLink.substring(
            trueVideoLink.length - 4, trueVideoLink.length) ==
        'm3u8') {
      final loadLink = link.replaceFirst('streaming', 'load', 16);
      print(loadLink);
      final m3u8Parser = new PageParser(url: 'http://' + loadLink);
      if (!(await m3u8Parser.parseData(_client, {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
      }))) return;
      final videoLink = m3u8Parser.document().getElementsByTagName('script');

      if (trueVideoLink.substring(
              trueVideoLink.length -
                  widget.episodeUrl.substring(28).length -
                  '.m3u8'.length,
              trueVideoLink.length) !=
          widget.episodeUrl.substring(28) + '.m3u8') {
        var vidLink = videoLink[2].text;
        // print(videoLink[2].text.substring(191, 329).trim());
        const start = "'";
        const end = "'";
        final startIndex = vidLink.indexOf(start);
        final endIndex = vidLink.indexOf(end, startIndex + start.length);
        trueVideoLink = vidLink.substring(startIndex + start.length, endIndex);
        final t = trueVideoLink.substring(81, 113);

        print(t);

        final temp = 'https://hls13x.cdnfile.info/stream/';
        trueVideoLink =
            temp + t + '/' + widget.episodeUrl.substring(28) + '.m3u8';
      } else {
        // if(videoLink[0].text.length < 200 || videoLink[0].text.isEmpty) {
        for (int i = 0; i < videoLink.length; ++i) {
          print("ITERATOR");
          if (videoLink[i].text.isNotEmpty) {
            if (videoLink[i].text.length > 200) {
              var vidLink = videoLink[i].text;
              print(vidLink);
              const start = "'";
              const end = "'";
              final startIndex = vidLink.indexOf(start);
              final endIndex = vidLink.indexOf(end, startIndex + start.length);
              trueVideoLink =
                  vidLink.substring(startIndex + start.length, endIndex);
              print('TRUE LINK: ' + trueVideoLink);
              break;
            }
          }
        }
      }
      print('Episode name + .M3U8: ' +
          trueVideoLink.substring(
              trueVideoLink.length -
                  widget.episodeUrl.substring(28).length -
                  '.m3u8'.length,
              trueVideoLink.length));
      // } else {
      //    }

      //fixing faulty links ^^^^^^^^^^^^^^^^^^^^^^^^ from stream.php to load.php and then getting new link

//https://hls13x.cdnfile.info/stream/2b6ae7027dfab875c9b80bed9e1c45a7/gegege-no-kitarou-2018-episode-96.m3u8
      print(trueVideoLink);
    }

    print(trueVideoLink);
    return trueVideoLink;
  }
}

/*
    setState(() {
      _controller = VideoPlayerController.network(trueVideoLink);
      _chewieController = ChewieController(
          cupertinoProgressColors: ChewieProgressColors(
              backgroundColor: Colors.black, bufferedColor: Colors.black54),
          materialProgressColors: ChewieProgressColors(
              backgroundColor: Colors.black, handleColor: Colors.black),
          videoPlayerController: _controller,
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: false);
    });

*/

/*
Text(
                    "Please spare a moment to click this ad below, those clicks keep the app alive and updated. We don't like to force people on ads, so it is your decision to click it or not.",
                    style: TextStyle(color: Colors.white.withOpacity(0.3))),
              )

*/