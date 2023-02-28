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
    "Lucky Captured": false,
    "Generation 1": false,
    "Generation 2": false,
    "Generation 3": false,
    "Generation 4": false,
    "Generation 5": false,
    "Generation 6": false,
    "Generation 7": false,
    "Generation 8": false,
    "Generation 9": false
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
          var card = PokemonCardController(PokemonAttribute.init, PokemonAttribute.init, value[index]);
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
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Loading all Pokemons ...", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 16, 170, 244),
                              strokeWidth: 10,
                            ),
                          )
                        ]),
                  );
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
                  padding: const EdgeInsets.only(left: 15, right: 15),
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
            final generation1 = filterValues['Generation 1'];
            final generation2 = filterValues['Generation 2'];
            final generation3 = filterValues['Generation 3'];
            final generation4 = filterValues['Generation 4'];
            final generation5 = filterValues['Generation 5'];
            final generation6 = filterValues['Generation 6'];
            final generation7 = filterValues['Generation 7'];
            final generation8 = filterValues['Generation 8'];
            final generation9 = filterValues['Generation 9'];

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
                ((generation1 == true && pokemon.generationId == 1) ||
                    (generation1 == null && pokemon.generationId != 1) ||
                    (generation1 == false)) &&
                ((generation2 == true && pokemon.generationId == 2) ||
                    (generation2 == null && pokemon.generationId != 2) ||
                    (generation2 == false)) &&
                ((generation3 == true && pokemon.generationId == 3) ||
                    (generation3 == null && pokemon.generationId != 3) ||
                    (generation3 == false)) &&
                ((generation4 == true && pokemon.generationId == 4) ||
                    (generation4 == null && pokemon.generationId != 4) ||
                    (generation4 == false)) &&
                ((generation5 == true && pokemon.generationId == 5) ||
                    (generation5 == null && pokemon.generationId != 5) ||
                    (generation5 == false)) &&
                ((generation6 == true && pokemon.generationId == 6) ||
                    (generation6 == null && pokemon.generationId != 6) ||
                    (generation6 == false)) &&
                ((generation7 == true && pokemon.generationId == 7) ||
                    (generation7 == null && pokemon.generationId != 7) ||
                    (generation7 == false)) &&
                ((generation8 == true && pokemon.generationId == 8) ||
                    (generation8 == null && pokemon.generationId != 8) ||
                    (generation8 == false)) &&
                ((generation9 == true && pokemon.generationId == 9) ||
                    (generation9 == null && pokemon.generationId != 9) ||
                    (generation9 == false)) &&
                (search.isEmpty ||
                    (pokemon.name.toLowerCase().contains(search) || pokemon.id.toString().contains(search)));
          }).toList());
    });
  }
}
