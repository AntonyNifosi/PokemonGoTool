import 'package:json_annotation/json_annotation.dart';
part 'pokemon.g.dart';

enum ArtworkType { male, female, maleshiny, femaleshiny, alola, alolashiny }

enum CaptureType {
  lucky,
  normal,
  normalMale,
  normalFemale,
  shiny,
  shinyMale,
  shinyFemale,
  alola,
  alolaShiny
}

enum PokemonForm { normal, alola }

enum PokemonGender { male, female, genderless, both }

@JsonSerializable()
class Pokemon {
  int id;
  String name;
  PokemonGender gender;
  Map<ArtworkType, String> artworks;
  String category = "";
  bool hasShinyVersion = false;
  bool hasAlolaForm = false;
  Set<CaptureType> captures = {};

  Pokemon(this.id, this.name, this.gender, this.category, this.artworks, this.hasShinyVersion,
      this.hasAlolaForm);

  bool isCaptured() {
    return captures.contains(CaptureType.normal) ||
        captures.contains(CaptureType.normalMale) ||
        captures.contains(CaptureType.normalFemale);
  }

  bool isShinyCaptured() {
    return captures.contains(CaptureType.shiny) ||
        captures.contains(CaptureType.shinyMale) ||
        captures.contains(CaptureType.shinyFemale);
  }

  bool isLuckyCaptured() {
    return captures.contains(CaptureType.lucky);
  }

  static Map<String, dynamic> toJson(Pokemon pokemon) => _$PokemonToJson(pokemon);
  static Pokemon fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);
}
