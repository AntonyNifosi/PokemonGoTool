// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
      json['id'] as int,
      json['name'] as String,
      json['category'] as String,
      json['artwork'] as String,
      json['hasShinyVersion'] as bool,
    )
      ..isMaleCaptured = json['isMaleCaptured'] as bool
      ..isFemaleCaptured = json['isFemaleCaptured'] as bool
      ..isMaleShinyCaptured = json['isMaleShinyCaptured'] as bool
      ..isLuckyCaptured = json['isFemaleLuckyCaptured'] as bool;

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'artwork': instance.artwork,
      'hasShinyVersion': instance.hasShinyVersion,
      'isMaleCaptured': instance.isMaleCaptured,
      'isFemaleCaptured': instance.isFemaleCaptured,
      'isMaleShinyCaptured': instance.isMaleShinyCaptured,
      'isFemaleLuckyCaptured': instance.isLuckyCaptured,
    };
