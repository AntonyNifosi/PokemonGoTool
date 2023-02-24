import 'package:bit_array/bit_array.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pokemon.g.dart';

enum ArtworkType { male, female, maleshiny, femaleshiny, alola, alolashiny }

enum PokemonType {
  init,
  male,
  female,
  genderless,
  normal,
  lucky,
  shiny,
  classicform,
  alolaform,
  galarform,
  size
}

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

  @JsonKey(
    toJson: _toJson,
    fromJson: _fromJson,
  )
  Set<BitArray> captured = {};

  static List<dynamic> _toJson(Set<BitArray> array) {
    List<String> listBit = [];
    for (BitArray bit in array) {
      listBit.add(bit.toBinaryString().split('').reversed.join());
    }
    return listBit;
  }

  static Set<BitArray> _fromJson(List<dynamic> listBit) {
    Set<BitArray> array = {};
    for (String bits in listBit) {
      array.add(BitArray.parseBinary(bits));
    }
    return array;
  }

  Pokemon(this.id, this.name, this.gender, this.category, this.artworks, this.hasShinyVersion,
      this.hasAlolaForm);

  PokemonGender getGender() {
    return gender;
  }

  bool isCaptured(BitArray pokeArray) {
    bool a = captured.contains(pokeArray);
    return a;
  }

  void capture(BitArray pokeArray) {
    captured.add(pokeArray);
  }

  void uncapture(BitArray pokeArray) {
    captured.remove(pokeArray);
  }

  List<PokemonType> _getPossibleGender() {
    switch (gender) {
      case PokemonGender.both:
        return [PokemonType.male, PokemonType.female];

      case PokemonGender.male:
        return [PokemonType.male];

      case PokemonGender.female:
        return [PokemonType.female];

      case PokemonGender.genderless:
        return [PokemonType.genderless];

      default:
        return [];
    }
  }

  List<PokemonType> _getPossibleForm() {
    List<PokemonType> formsList = [PokemonType.classicform];

    if (hasAlolaForm) {
      formsList.add(PokemonType.alolaform);
    }

    return formsList;
  }

  bool _isCapturedSpecific(
      List<PokemonType> genders, List<PokemonType> forms, PokemonType captureType) {
    bool isCaptured = true;
    if (forms.isNotEmpty) {
      for (var form in forms) {
        for (var gender in genders) {
          BitArray pokemonArray = BitArray(PokemonType.size.index);
          pokemonArray.setBit(gender.index);
          pokemonArray.setBit(form.index);
          pokemonArray.setBit(captureType.index);
          isCaptured = isCaptured && captured.contains(pokemonArray);
        }
      }
    } else {
      BitArray pokemonArray = BitArray(PokemonType.size.index);
      pokemonArray.setBit(captureType.index);
      isCaptured = isCaptured && captured.contains(pokemonArray);
    }
    return isCaptured;
  }

  bool isNormalCaptured() {
    List<PokemonType> genderList = _getPossibleGender();
    List<PokemonType> formsList = _getPossibleForm();
    PokemonType captureType = PokemonType.normal;

    return _isCapturedSpecific(genderList, formsList, captureType);
  }

  bool isShinyCaptured() {
    List<PokemonType> genderList = _getPossibleGender();
    List<PokemonType> formsList = _getPossibleForm();
    PokemonType captureType = PokemonType.shiny;

    return _isCapturedSpecific(genderList, formsList, captureType);
  }

  bool isLuckyCaptured() {
    List<PokemonType> genderList = [];
    List<PokemonType> formsList = [];
    PokemonType captureType = PokemonType.lucky;

    return _isCapturedSpecific(genderList, formsList, captureType);
  }

  static Map<String, dynamic> toJson(Pokemon pokemon) => _$PokemonToJson(pokemon);
  static Pokemon fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);
}
