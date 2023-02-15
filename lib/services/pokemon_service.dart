import 'package:pokegotool/services/api_service.dart';
import 'package:pokegotool/services/json_service.dart';
import '../models/pokemon.dart';

class PokemonService {
  static Future<List<Pokemon>> getPokemonList() async {
    List<Pokemon> pokemonList = await JSONService.pokemonsFromJson();

    if (pokemonList.isEmpty) {
      print("Je load avec l'API");
      pokemonList = await APIServices.getPokemonListFromAPI();
    }
    savePokemons(pokemonList);
    return pokemonList;
  }

  static void savePokemons(List<Pokemon> pokemonList) {
    JSONService.pokemonsToJson(pokemonList);
  }
}
