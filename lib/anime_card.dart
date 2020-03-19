import 'package:anime/anime_model.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  AnimeCard({this.animeModel});
  final AnimeModel animeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.network(animeModel.imgUrl, width: 170, height: 220, fit: BoxFit.fill,),
        ],
      ),
    );
  }
}

/*
Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: Text('Boruto: Naruto Next Generations', style: TextStyle(fontSize: 8)),
                ),
              )
            ),

*/

/*
Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FittedBox(           
            fit: BoxFit.fill,
            child: Image.network(
                animeModel.imgUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                          animeModel.name.toUpperCase(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center),
                    ))),
          )
        ],
      );

*/
