import 'package:json_annotation/json_annotation.dart';
part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  int id;
  String name;
  String category = "";
  String artwork;
  bool captured = false;
  bool hasShinyVersion = false;
  bool isShiny = false;
  bool isLucky = false;
  Pokemon(
      this.id, this.name, this.category, this.artwork, this.hasShinyVersion);

  static Map<String, dynamic> toJson(Pokemon pokemon) =>
      _$PokemonToJson(pokemon);

  static Pokemon fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);
}
