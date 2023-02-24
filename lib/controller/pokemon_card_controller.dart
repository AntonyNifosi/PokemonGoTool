import 'package:pokegotool/models/pokemon.dart';

class PokemonCardController {
  PokemonType currentGender;
  PokemonType currentForm;
  Pokemon pokemon;

  PokemonCardController(this.currentForm, this.currentGender, this.pokemon) {
    PokemonGender gender = pokemon.getGender();
    switch (gender) {
      case PokemonGender.genderless:
        currentGender = PokemonType.genderless;
        break;
      case PokemonGender.female:
        currentGender = PokemonType.female;
        break;
      default:
        currentGender = PokemonType.male;
    }
    currentForm = PokemonType.classicform;
  }
}
