import 'package:pokegotool/models/pokemon.dart';

class PokemonCardController {
  PokemonAttribute currentGender;
  PokemonAttribute currentForm;
  Pokemon pokemon;

  PokemonCardController(this.currentForm, this.currentGender, this.pokemon) {
    PokemonGender gender = pokemon.getGender();
    switch (gender) {
      case PokemonGender.genderless:
        currentGender = PokemonAttribute.genderless;
        break;
      case PokemonGender.female:
        currentGender = PokemonAttribute.female;
        break;
      default:
        currentGender = PokemonAttribute.male;
    }
    currentForm = PokemonAttribute.classicform;
  }
}
