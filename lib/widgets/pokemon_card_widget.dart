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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: Column(children: [
          Row(children: [
            Text(widget.pokemon.name, style: const TextStyle(fontSize: 15)),
            const Spacer(),
            Text("# ${widget.pokemon.id.toString()}",
                style: const TextStyle(fontSize: 15))
          ]),
          Expanded(
            child: widget.pokemon.artwork,
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.pokemon.captured = !widget.pokemon.captured;
                      });
                      widget.onCardChange();
                    },
                    icon: widget.pokemon.captured
                        ? const Icon(Icons.radio_button_checked_sharp,
                            color: Colors.blue)
                        : const Icon(Icons.radio_button_checked_sharp)),
                const Spacer(),
                if (widget.pokemon.hasShinyVersion)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.pokemon.isShiny = !widget.pokemon.isShiny;
                      });
                      widget.onCardChange();
                    },
                    icon: widget.pokemon.isShiny
                        ? const Icon(Icons.star,
                            color: Color.fromARGB(255, 236, 163, 4))
                        : const Icon(Icons.star),
                  ),
                if (!widget.pokemon.isMythic)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.pokemon.isLucky = !widget.pokemon.isLucky;
                      });
                      widget.onCardChange();
                    },
                    icon: widget.pokemon.isLucky
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
