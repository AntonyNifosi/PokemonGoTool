import 'package:flutter/material.dart';

class Pokemon {
  int id;
  String name;
  String category = "";
  Image artwork;
  bool captured = false;
  bool hasShinyVersion = false;
  bool isMythic = false;
  bool isShiny = false;
  bool isLucky = false;
  Pokemon(
      this.id, this.name, this.artwork, this.hasShinyVersion, this.isMythic);
}
