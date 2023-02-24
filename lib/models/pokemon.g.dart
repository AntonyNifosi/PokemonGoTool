// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
      json['id'] as int,
      json['name'] as String,
      $enumDecode(_$PokemonGenderEnumMap, json['gender']),
      json['category'] as String,
      (json['artworks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ArtworkTypeEnumMap, k), e as String),
      ),
      json['hasShinyVersion'] as bool,
      json['hasAlolaForm'] as bool,
    )..captured = Pokemon._fromJson(json['captured'] as List);

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': _$PokemonGenderEnumMap[instance.gender]!,
      'artworks': instance.artworks
          .map((k, e) => MapEntry(_$ArtworkTypeEnumMap[k]!, e)),
      'category': instance.category,
      'hasShinyVersion': instance.hasShinyVersion,
      'hasAlolaForm': instance.hasAlolaForm,
      'captured': Pokemon._toJson(instance.captured),
    };

const _$PokemonGenderEnumMap = {
  PokemonGender.male: 'male',
  PokemonGender.female: 'female',
  PokemonGender.genderless: 'genderless',
  PokemonGender.both: 'both',
};

const _$ArtworkTypeEnumMap = {
  ArtworkType.male: 'male',
  ArtworkType.female: 'female',
  ArtworkType.maleshiny: 'maleshiny',
  ArtworkType.femaleshiny: 'femaleshiny',
  ArtworkType.alola: 'alola',
  ArtworkType.alolashiny: 'alolashiny',
};
