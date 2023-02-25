import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pokegotool/models/api_version.dart';
import '../models/pokemon.dart';

class JSONService {
  static Future<String> get _localPath async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  static Future<File> get _localPokemonFile async {
    final path = await _localPath;
    return File('$path/pokemons.json');
  }

  static Future<File> get _localApiVersionFile async {
    final path = await _localPath;
    return File('$path/api.version');
  }

  static void pokemonsToJson(List<Pokemon> pokemonList) {
    List<Map<String, dynamic>> jsonList = [];
    for (var pokemon in pokemonList) {
      jsonList.add(Pokemon.toJson(pokemon));
    }
    _localPokemonFile.then((value) => value.writeAsString(convert.json.encode(jsonList)));
  }

  static Future<List<Pokemon>> pokemonsFromJson() async {
    List<Pokemon> pokemonList = [];
    var localFile = await _localPokemonFile;
    var jsonExist = await localFile.exists();

    if (jsonExist) {
      print("Je load avec le JSON");
      var content = await localFile.readAsString();
      var jsonContent = convert.jsonDecode(content) as List<dynamic>;
      for (var jsonPokemon in jsonContent) {
        pokemonList.add(Pokemon.fromJson(jsonPokemon));
      }
    }
    return pokemonList;
  }

  static void apiVersionToJson(ApiVersion apiVersion) {
    Map<String, dynamic> json = ApiVersion.toJson(apiVersion);
    _localApiVersionFile.then((value) => value.writeAsString(convert.json.encode(json)));
  }

  static Future<ApiVersion> apiVersionFromJson() async {
    ApiVersion apiVersion = ApiVersion({});
    var localFile = await _localApiVersionFile;
    var versionFileExist = await localFile.exists();

    if (versionFileExist) {
      var content = await localFile.readAsString();
      var jsonContent = convert.jsonDecode(content) as Map<String, dynamic>;
      apiVersion = ApiVersion.fromJson(jsonContent);
    }
    return apiVersion;
  }
}
