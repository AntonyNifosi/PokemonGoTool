import 'package:json_annotation/json_annotation.dart';
part 'pokemon.g.dart';

enum ArtworkType { male, female, maleshiny, femaleshiny, alola, alolashiny }

@JsonSerializable()
class Pokemon {
  int id;
  String name;
  int genderRate;
  Map<ArtworkType, String> artworks;
  String category = "";
  bool hasShinyVersion = false;
  bool hasAlolaForm = false;
  bool isMaleCaptured = false;
  bool isFemaleCaptured = false;
  bool isMaleShinyCaptured = false;
  bool isFemaleShinyCaptured = false;
  bool isLuckyCaptured = false;
  bool isAlolaCaptured = false;
  bool isAlolaShinyCaptured = false;

  Pokemon(this.id, this.name, this.genderRate, this.category, this.artworks, this.hasShinyVersion,
      this.hasAlolaForm);

  static Map<String, dynamic> toJson(Pokemon pokemon) => _$PokemonToJson(pokemon);
  static Pokemon fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);
}
