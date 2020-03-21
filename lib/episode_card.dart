import 'package:anime/view_page.dart';
import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  EpisodeCard({this.index, this.url});
  final int index;
  final String url;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ViewPage(
                      episodeUrl: 'https://www16.gogoanime.io/' +
                          url +
                          index.toString(), episode: index)));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text('Episode ' + index.toString(),
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
