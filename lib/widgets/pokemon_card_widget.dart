import 'package:bit_array/bit_array.dart';
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
  List<PokemonType> capturesType = [PokemonType.normal, PokemonType.shiny, PokemonType.lucky];
  late PokemonType currentGender;
  late PokemonType currentForm;

  Icon capturedIcon = const Icon(Icons.radio_button_checked_sharp, color: Colors.blue);
  Icon uncapturedIcon = const Icon(Icons.radio_button_checked_sharp);

  Icon shinyCapturedIcon = const Icon(Icons.star, color: Color.fromARGB(255, 236, 163, 4));
  Icon shinyUncapturedIcon = const Icon(Icons.star);

  Icon luckyCapturedIcon = const Icon(Icons.bubble_chart_rounded, color: Colors.pink);
  Icon luckyUncapturedIcon = const Icon(Icons.bubble_chart_rounded);

  late Icon currentCapturedIcon;
  late Icon currentCapturedShinyIcon;
  late Icon currentCapturedLuckyIcon;

  var iconsInfoTable = {};

  String artworkUrl = "";

  BitArray getPokemonBitArray() {
    BitArray array = BitArray(PokemonType.size.index);
    array.setBit(currentForm.index);
    array.setBit(currentGender.index);

    return array;
  }

  void setCardState() {
    PokemonGender gender = widget.pokemon.getGender();
    switch (gender) {
      case PokemonGender.genderless:
        currentGender = PokemonType.genderless;
        break;
      case PokemonGender.female:
        currentGender = PokemonType.female;
        break;
      default:
        currentGender = PokemonType.male;
    }
    currentForm = PokemonType.classicform;

    iconsInfoTable = {
      PokemonType.normal: {
        true: () {
          currentCapturedIcon = capturedIcon;
        },
        false: () {
          currentCapturedIcon = uncapturedIcon;
        }
      },
      PokemonType.shiny: {
        true: () {
          currentCapturedShinyIcon = shinyCapturedIcon;
        },
        false: () {
          currentCapturedShinyIcon = shinyUncapturedIcon;
        },
      },
      PokemonType.lucky: {
        true: () {
          currentCapturedLuckyIcon = luckyCapturedIcon;
        },
        false: () {
          currentCapturedLuckyIcon = luckyUncapturedIcon;
        },
      },
    };
  }

  void updateIcons() {
    for (var captureType in capturesType) {
      BitArray pokeArray;
      if (captureType == PokemonType.lucky) {
        pokeArray = BitArray(PokemonType.size.index);
      } else {
        pokeArray = getPokemonBitArray();
      }
      pokeArray.setBit(captureType.index);
      bool isCaptured = widget.pokemon.isCaptured(pokeArray);
      iconsInfoTable[captureType][isCaptured]();
    }
  }

  void onCaptureClick() {
    BitArray pokeArray = getPokemonBitArray();
    pokeArray.setBit(PokemonType.normal.index);
    widget.pokemon.isCaptured(pokeArray) ? widget.pokemon.uncapture(pokeArray) : widget.pokemon.capture(pokeArray);
  }

  void onShinyCaptureClick() {
    BitArray pokeArray = getPokemonBitArray();
    pokeArray.setBit(PokemonType.shiny.index);
    widget.pokemon.isCaptured(pokeArray) ? widget.pokemon.uncapture(pokeArray) : widget.pokemon.capture(pokeArray);
  }

  void onLuckyCaptureClick() {
    BitArray pokeArray = BitArray(PokemonType.size.index);
    pokeArray.setBit(PokemonType.lucky.index);
    widget.pokemon.isCaptured(pokeArray) ? widget.pokemon.uncapture(pokeArray) : widget.pokemon.capture(pokeArray);
  }

  @override
  void initState() {
    super.initState();
    setCardState();
  }

  @override
  Widget build(BuildContext context) {
    updateIcons();
    artworkUrl = widget.pokemon.artworks[ArtworkType.male]!;

    return Card(
      surfaceTintColor: Colors.blueGrey,
      shadowColor: Colors.black,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: Column(children: [
          Row(children: [
            Text("${widget.pokemon.name} - #${widget.pokemon.id.toString()}",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontFamily: "Bahnschrift")),
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
                value: currentForm == PokemonType.alolaform,
                onChanged: (bool value) {
                  setState(() {
                    value ? currentForm = PokemonType.alolaform : currentForm = PokemonType.classicform;
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
                value: currentGender == PokemonType.male,
                onChanged: (bool value) {
                  setState(() {
                    value ? currentGender = PokemonType.male : currentGender = PokemonType.female;
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
                        onCaptureClick();
                      });
                      widget.onCardChange();
                    },
                    icon: currentCapturedIcon),
                if (widget.pokemon.hasShinyVersion)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        onShinyCaptureClick();
                      });
                      widget.onCardChange();
                    },
                    icon: currentCapturedShinyIcon,
                  ),
                const Spacer(),
                if (widget.pokemon.category != "Mythic")
                  IconButton(
                    onPressed: () {
                      setState(() {
                        onLuckyCaptureClick();
                      });
                      widget.onCardChange();
                    },
                    icon: currentCapturedLuckyIcon,
                  ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
