import 'package:flutter/foundation.dart' show kIsWeb, mapEquals;
import 'package:pokegotool/models/api_version.dart';
import 'package:pokegotool/services/api_service.dart';
import 'package:pokegotool/services/json_service.dart';
import '../models/pokemon.dart';

class PokemonService {
  static Future<List<Pokemon>> getPokemonList() async {
    List<Pokemon> pokemonList = [];
    var apiVersion = await APIServices.getAPIVersions();

    if (kIsWeb) {
      pokemonList = await APIServices.getPokemonListFromAPI();
    } else {
      bool localApiUpToDate = await checkForAPIUpdate();
      pokemonList = await JSONService.pokemonsFromJson();

      if (pokemonList.isEmpty) {
        pokemonList = await APIServices.getPokemonListFromAPI();
        savePokemons(pokemonList);
      } else if (!localApiUpToDate) {
        var onlinePokemonList = await APIServices.getPokemonListFromAPI();
        pokemonList = updatePokemonList(pokemonList, onlinePokemonList);
        savePokemons(pokemonList);
      }
      saveAPIVersion(apiVersion);
    }
    return pokemonList;
  }

  static void savePokemons(List<Pokemon> pokemonsList) {
    if (!kIsWeb) {
      JSONService.pokemonsToJson(pokemonsList);
    }
  }

  static void saveAPIVersion(ApiVersion apiVersion) {
    if (!kIsWeb) {
      JSONService.apiVersionToJson(apiVersion);
    }
  }

  static Future<bool> checkForAPIUpdate() async {
    var localApiVersion = await JSONService.apiVersionFromJson();
    var onlineApiVersion = await APIServices.getAPIVersions();

    return mapEquals(localApiVersion.versions, onlineApiVersion.versions);
  }

  static List<Pokemon> updatePokemonList(List<Pokemon> localList, List<Pokemon> onlineList) {
    List<Pokemon> newPokemonList = [];
    Map<int, Pokemon> localPokemonMap = {};
    for (var pokemon in localList) {
      localPokemonMap[pokemon.id] = pokemon;
    }

    for (var pokemon in onlineList) {
      var newPokemon = pokemon; // We take the pokemon return by the API
      if (localPokemonMap.containsKey(pokemon.id)) {
        newPokemon.captured =
            localPokemonMap[pokemon.id]!.captured; // If we have local version of the pokemon we save the local captures
      }
      newPokemonList.add(newPokemon);
    }

    return newPokemonList;
  }
}
