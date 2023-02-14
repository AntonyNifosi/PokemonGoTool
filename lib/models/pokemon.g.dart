// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
      json['id'] as int,
      json['name'] as String,
      json['artwork'] as String,
      json['hasShinyVersion'] as bool,
      json['isMythic'] as bool,
    )
      ..category = json['category'] as String
      ..captured = json['captured'] as bool
      ..isShiny = json['isShiny'] as bool
      ..isLucky = json['isLucky'] as bool;

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'artwork': instance.artwork,
      'captured': instance.captured,
      'hasShinyVersion': instance.hasShinyVersion,
      'isMythic': instance.isMythic,
      'isShiny': instance.isShiny,
      'isLucky': instance.isLucky,
    };
