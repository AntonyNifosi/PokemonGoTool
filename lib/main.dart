import 'package:flutter/cupertino.dart';
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
  late Future<List<Pokemon>> pokemonsFullList;
  late List<Pokemon> pokemonsDisplayedList;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pokemonsFullList = APIServices.getPokemonList();
    pokemonsFullList.then((value) => pokemonsDisplayedList = value);
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
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pokemonsFullList = APIServices.getPokemonList();
                      pokemonsFullList
                          .then((value) => pokemonsDisplayedList = value);
                    });
                  },
                  child: const Text("Get Pokemon List")),
              SizedBox(
                width: 250,
                child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search ...',
                    ),
                    onChanged: (String value) {
                      setState(() {
                        pokemonsFullList.then((pokeList) =>
                            pokemonsDisplayedList = pokeList
                                .where((pokemon) => pokemon.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList());
                      });
                    }),
              ),
            ],
          ),
          FutureBuilder<List<Pokemon>>(
            future: pokemonsFullList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: GridView.builder(
                        addAutomaticKeepAlives: true,
                        cacheExtent: 10,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                        ),
                        itemCount: pokemonsDisplayedList.length,
                        itemBuilder: (BuildContext context, index) {
                          return PokemonCard(pokemonsDisplayedList[index]);
                        }));
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
    return pokemonList;
  }
}

class Pokemon {
  int id;
  String name;
  String category = "";
  Image artwork;
  bool hasShinyVersion = false;
  bool isMythic = false;
  bool isShiny = false;
  bool isLucky = false;
  Pokemon(
      this.id, this.name, this.artwork, this.hasShinyVersion, this.isMythic);
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: Column(children: [
          Row(children: [
            Text(pokemon.name, style: const TextStyle(fontSize: 15)),
            Spacer(),
            Text("# ${pokemon.id.toString()}",
                style: const TextStyle(fontSize: 15))
          ]),
          Expanded(
            child: pokemon.artwork,
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                if (pokemon.hasShinyVersion)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.star),
                  ),
                if (!pokemon.isMythic)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bubble_chart_rounded),
                  )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
