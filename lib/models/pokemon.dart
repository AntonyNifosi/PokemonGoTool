import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  int id;
  String name;
  String category = "";
  @JsonKey(
    toJson: _toJson,
    fromJson: _fromJson,
  )
  Image artwork;
  bool captured = false;
  bool hasShinyVersion = false;
  bool isMythic = false;
  bool isShiny = false;
  bool isLucky = false;
  Pokemon(
      this.id, this.name, this.artwork, this.hasShinyVersion, this.isMythic);

  static String _toJson(Image image) => "fdsf";
  static Image _fromJson(int value) => Image.network(
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/258.png",
        isAntiAlias: true,
      );
  static Map<String, dynamic> toJson(Pokemon pokemon) => _$PokemonToJson(pokemon);
}
