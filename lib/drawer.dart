import 'package:animist/anime_list_page.dart';
import 'package:animist/main_screen.dart';
import 'package:animist/movie_page.dart';
import 'package:animist/new_season_page.dart';
import 'package:animist/search_page.dart';
import 'package:flutter/material.dart';

class AnimistDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text('ANIMIST',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(-2, 2))
                      ])),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/drawer_image.png'),
                  fit: BoxFit.cover),
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text('Search'),
            onTap: () async {
              await Navigator.pushNamedAndRemoveUntil(
                  context, SearchPage.id, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text('Popular'),
            onTap: () async {
              await Navigator.pushNamedAndRemoveUntil(
                  context, MainPage.id, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text('New Season'),
            onTap: () async {
              //await Navigator.pushNamed(context, NewSeasonPage.id);
              await Navigator.pushNamedAndRemoveUntil(
                  context, NewSeasonPage.id, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text('Anime List'),
            onTap: () async {
              await Navigator.pushNamedAndRemoveUntil(
                  context, AnimeListPage.id, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text('Movies'),
            onTap: () async {
              await Navigator.pushNamedAndRemoveUntil(
                  context, MoviePage.id, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text('Close'),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
