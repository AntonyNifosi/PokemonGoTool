import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pokemon.dart';

class JSONService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/pokemons.json');
  }

  static void pokemonsToJson(List<Pokemon> pokemonList) {
    List<Map<String, dynamic>> jsonList = [];
    for (var pokemon in pokemonList) {
      jsonList.add(Pokemon.toJson(pokemon));
    }
    _localFile.then((value) => value.writeAsString(convert.json.encode(jsonList)));
  }

  static Future<List<Pokemon>> pokemonsFromJson() async {
    List<Pokemon> pokemonList = [];
    var localFile = await _localFile;
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
}
