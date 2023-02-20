import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIServices {
  static Future<Map<ArtworkType, String>> getArtworks(
      int pokemonId, bool hasGenderDiff, String alolaName) async {
    Map<ArtworkType, String> artworksList = {};
    artworksList[ArtworkType.male] =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonId.png";
    artworksList[ArtworkType.maleshiny] =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/$pokemonId.png";
    artworksList[ArtworkType.female] = artworksList[ArtworkType.male]!;
    artworksList[ArtworkType.femaleshiny] =
        artworksList[ArtworkType.maleshiny]!;

    if (hasGenderDiff) {
      artworksList[ArtworkType.female] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/female/$pokemonId.png";
      artworksList[ArtworkType.femaleshiny] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/female/$pokemonId.png";
    }

    if (alolaName.isNotEmpty) {
      var pokemonAlolaUrl =
          Uri.https("pokeapi.co", "/api/v2/pokemon/alolaName");
      var responsePokemonAlola = await http.get(pokemonAlolaUrl);
      if (responsePokemonAlola.statusCode == 200) {
        var jsonPokemonAlolaResponse = convert
            .jsonDecode(responsePokemonAlola.body) as Map<String, dynamic>;
        int id = jsonPokemonAlolaResponse["id"];
        artworksList[ArtworkType.alola] =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png";
        artworksList[ArtworkType.alolashiny] =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/$id.png";
      }
    }

    return artworksList;
  }

  static Future<Map<int, dynamic>> getPokemonsInfos() async {
    Map<int, dynamic> pokemonsInfosById = {};
    final response = await http.post(
      Uri.parse('https://beta.pokeapi.co/graphql/v1beta'),
      headers: {'Content-Type': 'application/json'},
      body: convert.json.encode({
        'query': '''
        {
          pokemon_v2_pokemonspecies(where: {pokemon_v2_pokemonspeciesnames: {language_id: {_eq: 5}}}) {
            id
            gender_rate
            has_gender_differences
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
      pokemonsInfosById = {
        for (var pokemon in data['data']['pokemon_v2_pokemonspecies'])
          pokemon['id']: {
            'french_name': pokemon['pokemon_v2_pokemonspeciesnames'][0]['name'],
            'gender_rate': pokemon['gender_rate'],
            'has_gender_differences': pokemon['has_gender_differences']
          }
      };
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return pokemonsInfosById;
  }

  static Future<List<Pokemon>> getPokemonListFromAPI() async {
    List<Pokemon> pokemonList = [];
    var pokemonsInfosByID = await getPokemonsInfos();
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
          var artwork = await getArtworks(
              pokemon["id"],
              pokemonsInfosByID[pokemon["id"]]["has_gender_differences"],
              "${pokemon["id"]["name"]}-alola");

          pokemonList.add(Pokemon(
              pokemon["id"],
              pokemonsInfosByID[pokemon["id"]]["french_name"]!,
              pokemonsInfosByID[pokemon["id"]]["gender_rate"]!,
              category,
              artwork,
              hasShinyVersion,
              artwork.containsKey("${pokemon["id"]["name"]}-alola")));
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
