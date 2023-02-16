// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:pokegotool/services/pokemon_service.dart';
import 'package:window_manager/window_manager.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/pokemon_card_widget.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> with WindowListener {
  late Future<List<Pokemon>> pokemonsFullList;
  late List<Pokemon> pokemonsDisplayedList;
  TextEditingController textController = TextEditingController();
  Map<String, bool?> filterValues = {
    "Captured": false,
    "Shiny Version Available": false,
    "Lucky Version Available": false,
    "Shiny Captured": false,
    "Lucky Captured": false
  };
  String searchName = "";

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    pokemonsFullList = PokemonService.getPokemonList();
    pokemonsFullList.then((value) => pokemonsDisplayedList = value);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    pokemonsFullList.then((value) => PokemonService.savePokemons(value));
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
          body: FutureBuilder<List<Pokemon>>(
            future: pokemonsFullList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: [
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pokemonsFullList =
                                  PokemonService.getPokemonList();
                              pokemonsFullList.then(
                                  (value) => pokemonsDisplayedList = value);
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
                              searchName = value;
                              applyFilter();
                            }),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            _dialogBuilder(context);
                          },
                          icon: const Icon(Icons.filter_list_outlined),
                          label: const Text("Filter"))
                    ],
                  ),
                  Expanded(
                      child: GridView.builder(
                          addAutomaticKeepAlives: true,
                          cacheExtent: 10,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                          ),
                          itemCount: pokemonsDisplayedList.length,
                          itemBuilder: (BuildContext context, index) {
                            return PokemonCard(
                              pokemonsDisplayedList[index],
                              () {
                                //applyFilter();
                              },
                            );
                          }))
                ]);
              } else {
                return const Text("NULL");
              }
            },
          ));
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SimpleDialog(
                  title: const Text('Filter Options'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[] +
                            (filterValues.entries
                                .map((e) => Row(
                                      children: [
                                        Text(e.key),
                                        const Spacer(),
                                        Checkbox(
                                          tristate: true,
                                          value: e.value,
                                          onChanged: (value) {
                                            setState(() {
                                              filterValues[e.key] = value;
                                            });
                                          },
                                        )
                                      ],
                                    ))
                                .toList()) +
                            [
                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Row(
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.close),
                                        label: const Text("Cancel")),
                                    const Spacer(),
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          applyFilter();
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.done),
                                        label: const Text("Apply"))
                                  ],
                                ),
                              )
                            ],
                      ),
                    ),
                  ]);
            },
          );
        });
  }

  void applyFilter() {
    setState(() {
      pokemonsFullList
          .then((pokeList) => pokemonsDisplayedList = pokeList.where(
                (pokemon) {
                  bool shouldAppear = true;
                  switch (filterValues["Captured"]) {
                    case true:
                      shouldAppear = shouldAppear && pokemon.captured;
                      break;
                    case null:
                      shouldAppear = shouldAppear && !pokemon.captured;
                      break;
                    default:
                      shouldAppear = shouldAppear && true;
                  }

                  switch (filterValues["Shiny Captured"]) {
                    case true:
                      shouldAppear = shouldAppear && pokemon.isShiny;
                      break;
                    case null:
                      shouldAppear = shouldAppear && !pokemon.isShiny;
                      break;
                    default:
                      shouldAppear = shouldAppear && true;
                  }

                  switch (filterValues["Lucky Captured"]) {
                    case true:
                      shouldAppear = shouldAppear && pokemon.isLucky;
                      break;
                    case null:
                      shouldAppear = shouldAppear && !pokemon.isLucky;
                      break;
                    default:
                      shouldAppear = shouldAppear && true;
                  }

                  switch (filterValues["Shiny Version Available"]) {
                    case true:
                      shouldAppear = shouldAppear && pokemon.hasShinyVersion;
                      break;
                    case null:
                      shouldAppear = shouldAppear && !pokemon.hasShinyVersion;
                      break;
                    default:
                      shouldAppear = shouldAppear && true;
                  }

                  switch (filterValues["Lucky Version Available"]) {
                    case true:
                      shouldAppear =
                          shouldAppear && pokemon.category != "Mythic";
                      break;
                    case null:
                      shouldAppear =
                          shouldAppear && pokemon.category == "Mythic";
                      break;
                    default:
                      shouldAppear = shouldAppear && true;
                  }

                  if (searchName.isNotEmpty) {
                    shouldAppear = shouldAppear &&
                        (pokemon.name
                                .toLowerCase()
                                .contains(searchName.toLowerCase()) ||
                            pokemon.id
                                .toString()
                                .toLowerCase()
                                .contains(searchName.toLowerCase()));
                  }
                  return shouldAppear;
                },
              ).toList());
    });
  }
}
