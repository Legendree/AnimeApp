import 'package:anime/page_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:video_player/video_player.dart';

class ViewPage extends StatefulWidget {
  ViewPage({this.episodeUrl});
  final String episodeUrl;
  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  //VideoPlayerController _controller;

  http.Client _client;
  dom.Document _parsedPage;

  String _videoLink = '';

  @override
  void initState() {
    super.initState();
    _client = new http.Client();
    print(widget.episodeUrl);
    _parsePage();
    //_controller = VideoPlayerController.network(
    //  'https://redirector.googlevideo.com/videoplayback?id=4a6c99e59a32ac21&itag=22&source=youtube&requiressl=yes&ei=wcJ0Xr7QCIWk7QT9iYaAAQ&susc=ytcp&mime=video/mp4&dur=1433.994&lmt=1584410328381367&txp=2216222&cmo=secure_transport=yes&ip=0.0.0.0&ipbits=0&expire=1584739137&sparams=ip,ipbits,expire,id,itag,source,requiressl,ei,susc,mime,dur,lmt&signature=47AEC855F4B5996392B146287373188C603C1FDFFDBB9D2D6CBFFA76CE610D0B.68A714F211448EFFEEDC9E2DA0772CEF86E5D6639C644E7D0F7FB1F59630F0D1&key=us0'
    //)..initialize().then((_) {
    //  setState(() {});
    //});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            //child: AspectRatio(
            //aspectRatio: 16 / 9,
            //child: VideoPlayer(_controller))
            ),
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

    print(link);

    final videoParser = new PageParser(url: 'http://' + link);
    if (!(await videoParser.parseData(_client, {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36'
    }))) return;

    print(videoParser.document().outerHtml);
  }
}
