import 'package:pokegotool/models/api_version.dart';

import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIServices {
  static Future<Map<ArtworkType, String>> getArtworks(
      int pokemonId, bool hasGenderDiff, int pokemonAlolaId, int pokemonGalarId, int pokemonHisuiId) async {
    Map<ArtworkType, String> artworksList = {};
    artworksList[ArtworkType.male] =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonId.png";
    artworksList[ArtworkType.maleshiny] =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/$pokemonId.png";
    artworksList[ArtworkType.female] = artworksList[ArtworkType.male]!;
    artworksList[ArtworkType.femaleshiny] = artworksList[ArtworkType.maleshiny]!;

    if (hasGenderDiff) {
      artworksList[ArtworkType.female] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/female/$pokemonId.png";
      artworksList[ArtworkType.femaleshiny] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/female/$pokemonId.png";
    }

    if (pokemonAlolaId > 0) {
      artworksList[ArtworkType.alola] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonAlolaId.png";
      artworksList[ArtworkType.alolashiny] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/$pokemonAlolaId.png";
    }

    if (pokemonGalarId > 0) {
      artworksList[ArtworkType.galar] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonGalarId.png";
      artworksList[ArtworkType.galarshiny] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/$pokemonGalarId.png";
    }

    if (pokemonHisuiId > 0) {
      artworksList[ArtworkType.hisui] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonHisuiId.png";
      artworksList[ArtworkType.hisuishiny] =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/$pokemonHisuiId.png";
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

  static Future<Map<String, int>> getPokemonsNameById() async {
    Map<String, int> pokemonsIdByName = {};
    final response = await http.post(
      Uri.parse('https://beta.pokeapi.co/graphql/v1beta'),
      headers: {'Content-Type': 'application/json'},
      body: convert.json.encode({
        'query': '''
        {
          pokemon_v2_pokemon {
            name
            id
          }
        }
      '''
      }),
    );

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      pokemonsIdByName = {for (var pokemon in data['data']['pokemon_v2_pokemon']) pokemon['name']: pokemon['id']};
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return pokemonsIdByName;
  }

  static Future<List<Pokemon>> getPokemonListFromAPI() async {
    List<Pokemon> pokemonList = [];
    var pokemonsInfosByID = await getPokemonsInfos();

    var pokemonsReleasedUrl = Uri.https("pogoapi.net", "/api/v1/released_pokemon.json");
    var pokemonsShinyUrl = Uri.https("pogoapi.net", "/api/v1/shiny_pokemon.json");
    var pokemonsCategoryUrl = Uri.https("pogoapi.net", "/api/v1/pokemon_rarity.json");

    var responsePokemonsReleasedList = await http.get(pokemonsReleasedUrl);
    var responsePokemonsShinyList = await http.get(pokemonsShinyUrl);
    var responsePokemonsMythicList = await http.get(pokemonsCategoryUrl);

    if (responsePokemonsReleasedList.statusCode == 200) {
      if (responsePokemonsShinyList.statusCode == 200) {
        if (responsePokemonsMythicList.statusCode == 200) {
          var jsonPokemonsListReleasedResponse =
              convert.jsonDecode(responsePokemonsReleasedList.body) as Map<String, dynamic>;
          var jsonPokemonsShinyListResponse =
              convert.jsonDecode(responsePokemonsShinyList.body) as Map<String, dynamic>;
          var jsonPokemonsMythicListResponse =
              convert.jsonDecode(responsePokemonsMythicList.body) as Map<String, dynamic>;

          Map<String, int> pokemonsIdByName = await getPokemonsNameById();

          final pokemonRarityMap = Map.fromEntries(jsonPokemonsMythicListResponse.values
              .expand((x) => x)
              .map((x) => MapEntry(x['pokemon_id'], x['rarity'])));

          for (var pokemon in jsonPokemonsListReleasedResponse.values) {
            bool hasShinyVersion = jsonPokemonsShinyListResponse.containsKey(pokemon["id"].toString());

            int pokemonAlolaId = -1;
            bool hasAlolaForm = pokemonsIdByName.containsKey("${pokemon["name"].toString().toLowerCase()}-alola");
            if (hasAlolaForm) {
              pokemonAlolaId = pokemonsIdByName["${pokemon["name"].toString().toLowerCase()}-alola"]!;
            }
            // Galar Form
            int pokemonGalarId = -1;
            bool hasGalarForm = pokemonsIdByName.containsKey("${pokemon["name"].toString().toLowerCase()}-galar");
            if (hasGalarForm) {
              pokemonGalarId = pokemonsIdByName["${pokemon["name"].toString().toLowerCase()}-galar"]!;
            } else {
              hasGalarForm = pokemonsIdByName.containsKey("${pokemon["name"].toString().toLowerCase()}-galar-standar");
            }
            // Hisui Form
            int pokemonHisuiId = -1;
            bool hasHisuiForm = pokemonsIdByName.containsKey("${pokemon["name"].toString().toLowerCase()}-hisui");
            if (hasHisuiForm) {
              pokemonHisuiId = pokemonsIdByName["${pokemon["name"].toString().toLowerCase()}-hisui"]!;
            }

            String category = pokemonRarityMap[pokemon["id"]];
            var artwork = await getArtworks(pokemon["id"], pokemonsInfosByID[pokemon["id"]]["has_gender_differences"],
                pokemonAlolaId, pokemonGalarId, pokemonHisuiId);
            var genderRate = pokemonsInfosByID[pokemon["id"]]["gender_rate"]!;
            var gender = PokemonGender.both;
            if (genderRate == -1) {
              gender = PokemonGender.genderless;
            } else if (genderRate == 0) {
              gender = PokemonGender.male;
            } else if (genderRate == 8) {
              gender = PokemonGender.female;
            }

            pokemonList.add(Pokemon(pokemon["id"], pokemonsInfosByID[pokemon["id"]]["french_name"]!, gender, category,
                artwork, hasShinyVersion, hasAlolaForm, hasGalarForm, hasHisuiForm));
          }
        }
      }
    } else {
      print('Request failed with status: ${responsePokemonsReleasedList.statusCode}.');
    }
    return pokemonList;
  }

  static Future<ApiVersion> getAPIVersions() async {
    ApiVersion apiVersion = ApiVersion({});

    var pokemonAPIVersionsUrl = Uri.https("pogoapi.net", "/api/v1/api_hashes.json");
    var responsePokemonsAPIVersions = await http.get(pokemonAPIVersionsUrl);

    if (responsePokemonsAPIVersions.statusCode == 200) {
      var jsonPokemonsAPIVersionsResponse =
          convert.jsonDecode(responsePokemonsAPIVersions.body) as Map<String, dynamic>;
      Map<String, String> versions = {};
      versions["released_pokemon.json"] = jsonPokemonsAPIVersionsResponse["released_pokemon.json"]["hash_sha256"];
      versions["shiny_pokemon.json"] = jsonPokemonsAPIVersionsResponse["shiny_pokemon.json"]["hash_sha256"];
      versions["pokemon_rarity.json"] = jsonPokemonsAPIVersionsResponse["pokemon_rarity.json"]["hash_sha256"];
      versions["alolan_pokemon.json"] = jsonPokemonsAPIVersionsResponse["alolan_pokemon.json"]["hash_sha256"];

      apiVersion = ApiVersion(versions);
    }
    return apiVersion;
  }
}
