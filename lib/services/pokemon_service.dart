import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pokegotool/services/api_service.dart';
import 'package:pokegotool/services/json_service.dart';
import '../models/pokemon.dart';

class PokemonService {
  static Future<List<Pokemon>> getPokemonList() async {
    List<Pokemon> pokemonList = [];
    if (kIsWeb) {
      pokemonList = await APIServices.getPokemonListFromAPI();
    } else {
      pokemonList = await JSONService.pokemonsFromJson();
      if (pokemonList.isEmpty) {
        pokemonList = await APIServices.getPokemonListFromAPI();
        savePokemons(pokemonList);
      }
    }
    return pokemonList;
  }

  static void savePokemons(List<Pokemon> pokemonsList) {
    if (!kIsWeb) {
      JSONService.pokemonsToJson(pokemonsList);
    }
  }
}
