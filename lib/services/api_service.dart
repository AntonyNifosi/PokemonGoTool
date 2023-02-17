import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIServices {
  static String getArtwork(int pokemonId) {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonId.png";
    /*return Image.network(
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png");*/
  }

  static Future<Map<int, String>> getFrenchName() async {
    Map<int, String> pokemonsNameById = {};
    final response = await http.post(
      Uri.parse('https://beta.pokeapi.co/graphql/v1beta'),
      headers: {'Content-Type': 'application/json'},
      body: convert.json.encode({
        'query': '''
        {
          pokemon_v2_pokemonspecies(where: {pokemon_v2_pokemonspeciesnames: {language_id: {_eq: 5}}}) {
            id
            pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 5}}) {
              name
            }
          }
        }
      '''
      }),
    );

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      pokemonsNameById = {
        for (var pokemon in data['data']['pokemon_v2_pokemonspecies'])
          pokemon['id']: pokemon['pokemon_v2_pokemonspeciesnames'][0]['name']
      };
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return pokemonsNameById;
  }

  static Future<List<Pokemon>> getPokemonListFromAPI() async {
    List<Pokemon> pokemonList = [];
    var pokemonNameByID = await getFrenchName();
    var pokemonsReleasedUrl =
        Uri.https("pogoapi.net", "/api/v1/released_pokemon.json");

    var pokemonsShinyUrl =
        Uri.https("pogoapi.net", "/api/v1/shiny_pokemon.json");

    var pokemonsCategoryUrl =
        Uri.https("pogoapi.net", "/api/v1/pokemon_rarity.json");

    var responsePokemonsList = await http.get(pokemonsReleasedUrl);
    var responsePokemonsShinyList = await http.get(pokemonsShinyUrl);
    var responsePokemonsMythicList = await http.get(pokemonsCategoryUrl);

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

          String category = pokemonRarityMap[pokemon["id"]];
          String artwork = getArtwork(pokemon["id"]);

          pokemonList.add(Pokemon(
              pokemon["id"],
              pokemonNameByID[pokemon["id"]]!,
              category,
              artwork,
              hasShinyVersion));
        }
      } else {
        print(
            'Request failed with status: ${responsePokemonsList.statusCode}.');
      }
    } else {
      print('Request failed with status: ${responsePokemonsList.statusCode}.');
    }

    //JSONService.pokemonsToJson(pokemonList);

    return pokemonList;
  }
}
