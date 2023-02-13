import 'package:flutter/material.dart';
import 'package:pokegotool/services/json_service.dart';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIServices {
  static Image getArtwork(int pokemonId) {
    return Image.network(
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonId.png",
      isAntiAlias: true,
    );
    /*return Image.network(
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png");*/
  }

  static Future<List<Pokemon>> getPokemonList() async {
    List<Pokemon> pokemonList = [];
    var pokemonsReleasedUrl =
        Uri.https("pogoapi.net", "/api/v1/released_pokemon.json");

    var pokemonsShinyUrl =
        Uri.https("pogoapi.net", "/api/v1/shiny_pokemon.json");

    var pokemonsMythicUrl =
        Uri.https("pogoapi.net", "/api/v1/pokemon_rarity.json");

    var responsePokemonsList = await http.get(pokemonsReleasedUrl);
    var responsePokemonsShinyList = await http.get(pokemonsShinyUrl);
    var responsePokemonsMythicList = await http.get(pokemonsMythicUrl);

    if (responsePokemonsList.statusCode == 200) {
      if (responsePokemonsShinyList.statusCode == 200) {
        var jsonPokemonsListResponse = convert
            .jsonDecode(responsePokemonsList.body) as Map<String, dynamic>;
        var jsonPokemonsShinyListResponse = convert
            .jsonDecode(responsePokemonsShinyList.body) as Map<String, dynamic>;
        var jsonPokemonsMythicListResponse =
            convert.jsonDecode(responsePokemonsMythicList.body)
                as Map<String, dynamic>;

        final pokemonRarityMap = Map.fromEntries(jsonPokemonsMythicListResponse
            .values
            .expand((x) => x)
            .map((x) => MapEntry(x['pokemon_id'], x['rarity'])));

        for (var pokemon in jsonPokemonsListResponse.values) {
          bool hasShinyVersion = (jsonPokemonsShinyListResponse
              .containsKey(pokemon["id"].toString()));

          bool isMythic = pokemonRarityMap[pokemon["id"]] == "Mythic";
          Image artwork = getArtwork(pokemon["id"]);

          pokemonList.add(Pokemon(pokemon["id"], pokemon["name"], artwork,
              hasShinyVersion, isMythic));
        }
      } else {
        print(
            'Request failed with status: ${responsePokemonsList.statusCode}.');
      }
    } else {
      print('Request failed with status: ${responsePokemonsList.statusCode}.');
    }

    for (var pokemon in pokemonList) {
      JSONService jsonService;
      jsonService.pokemonToJson(pokemon);
    }

    return pokemonList;
  }
}
