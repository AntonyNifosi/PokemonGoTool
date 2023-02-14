import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pokegotool/models/pokemon.dart';

class JSONService {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/pokemons.json');
  }

  static void pokemonsToJson(List<Pokemon> pokemonList)  async{

    List<Map<String, dynamic>> jsonList = [];
    for (var pokemon in pokemonList) {
      jsonList.add(Pokemon.toJson(pokemon));
    }
    print(jsonList);
    final file = await _localFile;

  // Write the file
    file.writeAsString("$jsonList");
  }
}
