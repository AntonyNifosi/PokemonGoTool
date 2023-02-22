import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  final VoidCallback onCardChange;
  const PokemonCard(this.pokemon, this.onCardChange, {super.key});
  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  var currentGender = PokemonGender.male;
  var currentForm = PokemonForm.normal;

  late Icon capturedIcon;
  late Icon capturedShinyIcon;
  String artworkUrl = "";

  var captureInfoTable = {};
  var artworksInfoTable = {};
  var iconCaptureInfoTable = {};
  var iconShinyInfoTable = {};

  void initCaptureTableInfo() {
    var alolaCaptureMap = {
      CaptureType.lucky: CaptureType.lucky,
      CaptureType.normal: CaptureType.alola,
      CaptureType.shiny: CaptureType.alolaShiny
    };

    captureInfoTable = {
      PokemonForm.normal: {
        PokemonGender.male: {
          CaptureType.lucky: CaptureType.lucky,
          CaptureType.normal: CaptureType.normalMale,
          CaptureType.shiny: CaptureType.shinyMale
        },
        PokemonGender.female: {
          CaptureType.lucky: CaptureType.lucky,
          CaptureType.normal: CaptureType.normalFemale,
          CaptureType.shiny: CaptureType.shinyFemale
        },
        PokemonGender.genderless: {
          CaptureType.lucky: CaptureType.lucky,
          CaptureType.normal: CaptureType.normal,
          CaptureType.shiny: CaptureType.shiny
        }
      },
      PokemonForm.alola: {
        PokemonGender.male: alolaCaptureMap,
        PokemonGender.female: alolaCaptureMap,
        PokemonGender.genderless: alolaCaptureMap
      }
    };
  }

  void initIconsTableInfo() {
    Icon capturedIcon = const Icon(Icons.radio_button_checked_sharp, color: Colors.blue);
    Icon uncapturedIcon = const Icon(Icons.radio_button_checked_sharp);

    Icon shinyCapturedIcon = const Icon(Icons.star, color: Color.fromARGB(255, 236, 163, 4));
    Icon shinyUncapturedIcon = const Icon(Icons.star);

    iconCaptureInfoTable = {
      PokemonForm.normal: {
        PokemonGender.male: {true: capturedIcon, false: uncapturedIcon},
        PokemonGender.female: {true: capturedIcon, false: uncapturedIcon},
        PokemonGender.genderless: {true: capturedIcon, false: uncapturedIcon}
      },
      PokemonForm.alola: {
        PokemonGender.male: {true: capturedIcon, false: uncapturedIcon},
        PokemonGender.female: {true: capturedIcon, false: uncapturedIcon},
        PokemonGender.genderless: {true: capturedIcon, false: uncapturedIcon}
      }
    };

    iconShinyInfoTable = {
      PokemonForm.normal: {
        PokemonGender.male: {true: shinyCapturedIcon, false: shinyUncapturedIcon},
        PokemonGender.female: {true: shinyCapturedIcon, false: shinyUncapturedIcon},
        PokemonGender.genderless: {true: shinyCapturedIcon, false: shinyUncapturedIcon}
      },
      PokemonForm.alola: {
        PokemonGender.male: {true: shinyCapturedIcon, false: shinyUncapturedIcon},
        PokemonGender.female: {true: shinyCapturedIcon, false: shinyUncapturedIcon},
        PokemonGender.genderless: {true: shinyCapturedIcon, false: shinyUncapturedIcon}
      }
    };
  }

  void initArtworkTableInfo() {
    artworksInfoTable = {
      PokemonForm.normal: {
        PokemonGender.male: {true: ArtworkType.maleshiny, false: ArtworkType.male},
        PokemonGender.female: {true: ArtworkType.femaleshiny, false: ArtworkType.female},
        PokemonGender.genderless: {true: ArtworkType.maleshiny, false: ArtworkType.male}
      },
      PokemonForm.alola: {
        PokemonGender.male: {true: ArtworkType.alolashiny, false: ArtworkType.alola},
        PokemonGender.female: {true: ArtworkType.alolashiny, false: ArtworkType.alola},
        PokemonGender.genderless: {true: ArtworkType.alolashiny, false: ArtworkType.alola}
      }
    };
  }

  void initTableInfo() {
    initCaptureTableInfo();
    initIconsTableInfo();
    initArtworkTableInfo();
  }

  @override
  void initState() {
    super.initState();
    initTableInfo();
  }

  @override
  Widget build(BuildContext context) {
    artworkUrl = widget.pokemon.artworks[artworksInfoTable[currentForm][currentGender][widget
        .pokemon.captures
        .contains(captureInfoTable[currentForm][currentGender][CaptureType.shiny])]]!;
    capturedIcon = iconCaptureInfoTable[currentForm][currentGender][widget.pokemon.captures
        .contains(captureInfoTable[currentForm][currentGender][CaptureType.normal])];
    capturedShinyIcon = iconShinyInfoTable[currentForm][currentGender][widget.pokemon.captures
        .contains(captureInfoTable[currentForm][currentGender][CaptureType.shiny])];

    return Card(
      surfaceTintColor: Colors.blueGrey,
      shadowColor: Colors.black,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: Column(children: [
          Row(children: [
            Text("${widget.pokemon.name} - #${widget.pokemon.id.toString()}",
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w400, fontFamily: "Bahnschrift")),
            const Spacer(),
            if (widget.pokemon.hasAlolaForm)
              Switch(
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.brightness_4_outlined);
                    }
                    return const Icon(Icons.brightness_4_outlined);
                  },
                ),
                activeColor: const Color.fromARGB(255, 101, 211, 255),
                inactiveThumbColor: const Color.fromARGB(255, 85, 87, 86),
                activeTrackColor: const Color.fromARGB(255, 209, 207, 207),
                inactiveTrackColor: const Color.fromARGB(255, 209, 207, 207),
                value: currentForm == PokemonForm.alola,
                onChanged: (bool value) {
                  setState(() {
                    value ? currentForm = PokemonForm.alola : currentForm = PokemonForm.normal;
                  });
                },
              ),
            if (widget.pokemon.gender == PokemonGender.genderless)
              const Icon(
                Icons.transgender_outlined,
                color: Colors.purple,
              ),
            if (widget.pokemon.gender == PokemonGender.male)
              const Icon(
                Icons.male_outlined,
                color: Colors.blue,
              ),
            if (widget.pokemon.gender == PokemonGender.female)
              const Icon(
                Icons.female_outlined,
                color: Colors.pink,
              ),
            if (widget.pokemon.gender == PokemonGender.both)
              Switch(
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.male_outlined);
                    }
                    return const Icon(Icons.female_outlined);
                  },
                ),
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.pink,
                activeTrackColor: const Color.fromARGB(255, 209, 207, 207),
                inactiveTrackColor: const Color.fromARGB(255, 209, 207, 207),
                value: currentGender == PokemonGender.male,
                onChanged: (bool value) {
                  setState(() {
                    value
                        ? currentGender = PokemonGender.male
                        : currentGender = PokemonGender.female;
                  });
                },
              ),
          ]),
          Expanded(
            child: Image.network(
              artworkUrl,
              filterQuality: FilterQuality.medium,
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        var capture =
                            captureInfoTable[currentForm][currentGender][CaptureType.normal];
                        if (!(widget.pokemon.captures.remove(capture))) {
                          widget.pokemon.captures.add(capture);
                        }
                      });
                      widget.onCardChange();
                    },
                    icon: capturedIcon),
                if (widget.pokemon.hasShinyVersion)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        var capture =
                            captureInfoTable[currentForm][currentGender][CaptureType.shiny];
                        if (!(widget.pokemon.captures.remove(capture))) {
                          widget.pokemon.captures.add(capture);
                        }
                      });
                      widget.onCardChange();
                    },
                    icon: capturedShinyIcon,
                  ),
                const Spacer(),
                if (widget.pokemon.category != "Mythic")
                  IconButton(
                    onPressed: () {
                      setState(() {
                        var capture =
                            captureInfoTable[currentForm][currentGender][CaptureType.lucky];
                        if (!(widget.pokemon.captures.remove(capture))) {
                          widget.pokemon.captures.add(capture);
                        }
                      });
                      widget.onCardChange();
                    },
                    icon: widget.pokemon.captures.contains(CaptureType.lucky)
                        ? const Icon(
                            Icons.bubble_chart_rounded,
                            color: Colors.pink,
                          )
                        : const Icon(Icons.bubble_chart_rounded),
                  ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
