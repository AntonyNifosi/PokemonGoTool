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
  bool isCurrentGenderMale = true;
  bool isCurrentFormAlola = false;
  Icon capturedIcon = const Icon(Icons.radio_button_checked_sharp);
  Icon shinyCapturedIcon = const Icon(Icons.star);
  String artworkUrl = "";

  void updateAllIcons() {
    updateCapturedIcon();
    updateShinyCapturedIcon();
  }

  void updateCapturedIcon() {}

  void updateShinyCapturedIcon() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Colors if the icons depending of the sexe
    if (isCurrentGenderMale) {
      artworkUrl = widget.pokemon.artworks[ArtworkType.male]!;

      if (widget.pokemon.isMaleCaptured) {
        capturedIcon =
            const Icon(Icons.radio_button_checked_sharp, color: Colors.blue);
      } else {
        capturedIcon = const Icon(Icons.radio_button_checked_sharp);
      }
      if (widget.pokemon.isMaleShinyCaptured) {
        artworkUrl = widget.pokemon.artworks[ArtworkType.maleshiny]!;

        shinyCapturedIcon =
            const Icon(Icons.star, color: Color.fromARGB(255, 236, 163, 4));
      } else {
        shinyCapturedIcon = const Icon(Icons.star);
      }
    } else {
      artworkUrl = widget.pokemon.artworks[ArtworkType.female]!;

      if (widget.pokemon.isFemaleCaptured) {
        capturedIcon =
            const Icon(Icons.radio_button_checked_sharp, color: Colors.blue);
      } else {
        capturedIcon = const Icon(Icons.radio_button_checked_sharp);
      }
      if (widget.pokemon.isFemaleShinyCaptured) {
        artworkUrl = widget.pokemon.artworks[ArtworkType.femaleshiny]!;

        shinyCapturedIcon =
            const Icon(Icons.star, color: Color.fromARGB(255, 236, 163, 4));
      } else {
        shinyCapturedIcon = const Icon(Icons.star);
      }
    }
    // Cas si la forme alola est coché
    if (isCurrentFormAlola && widget.pokemon.hasAlolaForm) {
      artworkUrl = widget.pokemon.artworks[ArtworkType.alola]!;
      if (widget.pokemon.isAlolaCaptured) {
        capturedIcon =
            const Icon(Icons.radio_button_checked_sharp, color: Colors.blue);
      } else {
        capturedIcon = const Icon(Icons.radio_button_checked_sharp);
      }
      if (widget.pokemon.isAlolaShinyCaptured) {
        artworkUrl = widget.pokemon.artworks[ArtworkType.alolashiny]!;
        shinyCapturedIcon =
            const Icon(Icons.star, color: Color.fromARGB(255, 236, 163, 4));
      } else {
        shinyCapturedIcon = const Icon(Icons.star);
      }
    }

    return Card(
      surfaceTintColor: Colors.blueGrey,
      shadowColor: Colors.black,
      elevation: 5,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: Column(children: [
          Row(children: [
            Text("${widget.pokemon.name} - #${widget.pokemon.id.toString()}",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Bahnschrift")),
            const Spacer(),
            if (widget.pokemon.hasAlolaForm)
              Switch(
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.brightness_4_outlined);
                    }
                    return const Icon(Icons.south_america_outlined);
                  },
                ),
                activeColor: const Color.fromARGB(255, 193, 226, 244),
                inactiveThumbColor: Colors.green,
                activeTrackColor: const Color.fromARGB(255, 209, 207, 207),
                inactiveTrackColor: const Color.fromARGB(255, 209, 207, 207),
                value: isCurrentFormAlola,
                onChanged: (bool value) {
                  setState(() {
                    isCurrentFormAlola = value;
                  });
                },
              ),
            if (widget.pokemon.genderRate == -1)
              const Icon(
                Icons.transgender_outlined,
                color: Colors.purple,
              ),
            if (widget.pokemon.genderRate == 0)
              const Icon(
                Icons.male_outlined,
                color: Colors.blue,
              ),
            if (widget.pokemon.genderRate == 8)
              const Icon(
                Icons.female_outlined,
                color: Colors.pink,
              ),
            if (widget.pokemon.genderRate > 0 && widget.pokemon.genderRate < 8)
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
                value: isCurrentGenderMale,
                onChanged: (bool value) {
                  setState(() {
                    isCurrentGenderMale = value;
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
                        if (isCurrentFormAlola) {
                          widget.pokemon.isAlolaCaptured =
                              !widget.pokemon.isAlolaCaptured;
                        } else if (isCurrentGenderMale) {
                          widget.pokemon.isMaleCaptured =
                              !widget.pokemon.isMaleCaptured;
                        } else {
                          widget.pokemon.isFemaleCaptured =
                              !widget.pokemon.isFemaleCaptured;
                        }
                      });
                      widget.onCardChange();
                    },
                    icon: capturedIcon),
                if (widget.pokemon.hasShinyVersion)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (isCurrentFormAlola) {
                          widget.pokemon.isAlolaShinyCaptured =
                              !widget.pokemon.isAlolaShinyCaptured;
                        } else if (isCurrentGenderMale) {
                          widget.pokemon.isMaleShinyCaptured =
                              !widget.pokemon.isMaleShinyCaptured;
                        } else {
                          widget.pokemon.isFemaleShinyCaptured =
                              !widget.pokemon.isFemaleShinyCaptured;
                        }
                      });
                      widget.onCardChange();
                    },
                    icon: shinyCapturedIcon,
                  ),
                const Spacer(),
                if (widget.pokemon.category != "Mythic")
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.pokemon.isLuckyCaptured =
                            !widget.pokemon.isLuckyCaptured;
                      });
                      widget.onCardChange();
                    },
                    icon: widget.pokemon.isLuckyCaptured
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
