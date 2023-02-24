// ignore_for_file: unused_import

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pokegotool/controller/pokemon_card_controller.dart';
import 'package:pokegotool/services/pokemon_service.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/pokemon_card_widget.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late Future<List<Pokemon>> pokemonsFullList;
  late List<Pokemon> pokemonsDisplayedList;
  late List<PokemonCardController> controllerCardList;
  Map<Pokemon, PokemonCardController> controllerMap = {};
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
    super.initState();
    pokemonsFullList = PokemonService.getPokemonList();

    pokemonsFullList.then(
      (value) {
        pokemonsDisplayedList = value;
        controllerCardList = List.generate(value.length, (index) {
          var card = PokemonCardController(PokemonType.init, PokemonType.init, value[index]);
          controllerMap[value[index]] = card;
          return card;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
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
            shadowColor: Colors.black,
            backgroundColor: Colors.blue,
            elevation: 5,
            scrolledUnderElevation: 10,
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 25, left: 5, right: 5),
            child: FutureBuilder<List<Pokemon>>(
              future: pokemonsFullList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: TextField(
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                  hintText: 'Search ...',
                                ),
                                onChanged: (String value) {
                                  searchName = value;
                                  applyFilter();
                                }),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          ElevatedButton.icon(
                              onPressed: () {
                                _dialogBuilder(context);
                              },
                              icon: const Icon(Icons.filter_list_outlined),
                              label: const Text("Filter"))
                        ],
                      ),
                    ),
                    Expanded(
                        child: GridView.builder(
                            addAutomaticKeepAlives: true,
                            cacheExtent: 1000,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              childAspectRatio: 1.8,
                              maxCrossAxisExtent: 550,
                            ),
                            itemCount: pokemonsDisplayedList.length,
                            itemBuilder: (BuildContext context, index) {
                              return PokemonCard(
                                pokemonsDisplayedList[index],
                                () {
                                  applyFilter();
                                  pokemonsFullList.then((value) => PokemonService.savePokemons(value));
                                },
                                controllerMap[pokemonsDisplayedList[index]]!,
                              );
                            }))
                  ]);
                } else {
                  return const Text("NULL");
                }
              },
            ),
          ));
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SimpleDialog(title: const Text('Filter Options'), children: [
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
      pokemonsFullList.then((pokeList) => pokemonsDisplayedList = pokeList.where((pokemon) {
            final search = searchName.toLowerCase();
            final captured = filterValues['Captured'];
            final shinyCaptured = filterValues['Shiny Captured'];
            final luckyCaptured = filterValues['Lucky Captured'];
            final shinyVersionAvailable = filterValues['Shiny Version Available'];
            final luckyVersionAvailable = filterValues['Lucky Version Available'];

            return ((captured == true && pokemon.isNormalCaptured()) ||
                    (captured == null && !pokemon.isNormalCaptured()) ||
                    (captured == false)) &&
                ((shinyCaptured == true && pokemon.isShinyCaptured()) ||
                    (shinyCaptured == null && !pokemon.isShinyCaptured()) ||
                    (shinyCaptured == false)) &&
                ((luckyCaptured == true && pokemon.isLuckyCaptured()) ||
                    (luckyCaptured == null && !pokemon.isLuckyCaptured()) ||
                    (luckyCaptured == false)) &&
                ((shinyVersionAvailable == true && pokemon.hasShinyVersion) ||
                    (shinyVersionAvailable == null && !pokemon.hasShinyVersion) ||
                    (shinyVersionAvailable == false)) &&
                ((luckyVersionAvailable == true && pokemon.category != 'Mythic') ||
                    (luckyVersionAvailable == null && pokemon.category == 'Mythic') ||
                    (luckyVersionAvailable == false)) &&
                (search.isEmpty ||
                    (pokemon.name.toLowerCase().contains(search) || pokemon.id.toString().contains(search)));
          }).toList());
    });
  }
}
