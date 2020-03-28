import 'package:animist/anime_model.dart';
import 'package:animist/anime_page.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  AnimeCard({this.animeModel});
  final AnimeModel animeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AnimePage(animeModel: animeModel)));
        },
        child: Stack(
          children: <Widget>[
            animeModel.imgUrl != null
                ? Image.network(animeModel.imgUrl,
                    width: 170, height: 220, fit: BoxFit.fill)
                : Image.asset('images/img_block.png',
                    width: 170, height: 220, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(animeModel.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        )),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

/*
Image.network(animeModel.imgUrl,
        width: 170, height: 220, fit: BoxFit.fill)

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
