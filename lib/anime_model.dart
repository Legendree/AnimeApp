import 'package:flutter/material.dart';

class AnimeModel {
  AnimeModel(
      {this.name,
      this.imgUrl,
      this.releaseYear,
      this.animeUrl,
      @required this.isAd});
  final String name;
  final String imgUrl;
  final String releaseYear;
  final String animeUrl;
  final bool isAd;
}
