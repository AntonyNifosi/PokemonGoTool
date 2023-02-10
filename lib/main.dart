import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Setup Workspace',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: const PokemonPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late Future<List<Pokemon>> pokemonsList;

  @override
  void initState() {
    super.initState();
    pokemonsList = APIServices.getPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pokemon Go Tool",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          elevation: 10,
        ),
        body: Column(children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  pokemonsList = APIServices.getPokemonList();
                });
              },
              child: const Text("Get Pokemon List")),
          FutureBuilder<List<Pokemon>>(
            future: pokemonsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                      ),
                      children: snapshot.data!
                          .map(
                            (e) => PokemonCard(e),
                          )
                          .toList()),
                );
              } else {
                return const Text("NULL");
              }
            },
          )
        ]),
      );
    });
  }
}

class APIServices {
  static Image getArtwork(int pokemonId) {
    return Image.network(
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonId.png");
  }

  static Future<List<Pokemon>> getPokemonList() async {
    List<Pokemon> pokemonList = [];
    var pokemonsReleasedUrl =
        Uri.https("pogoapi.net", "/api/v1/released_pokemon.json");

    var response = await http.get(pokemonsReleasedUrl);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      for (var pokemon in jsonResponse.values) {
        print("Pokemon name : ${pokemon["name"]} - Id : ${pokemon["id"]}");
        Image artwork = getArtwork(pokemon["id"]);
        pokemonList.add(Pokemon(pokemon["id"], pokemon["name"], artwork));
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return pokemonList;
  }
}

class Pokemon {
  int id;
  String name;
  String cathegory = "";
  Image artwork;
  bool hasShinyVersion = false;
  bool hasLuckyVersion = false;
  bool isShiny = false;
  bool isLucky = false;
  Pokemon(this.id, this.name, this.artwork);
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(pokemon.name),
        Expanded(
          child: pokemon.artwork,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.star),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_outlined),
            )
          ],
        )
      ]),
    );
  }
}
