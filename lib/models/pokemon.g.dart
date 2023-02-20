// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
      json['id'] as int,
      json['name'] as String,
      json['genderRate'] as int,
      json['category'] as String,
      (json['artworks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ArtworkTypeEnumMap, k), e as String),
      ),
      json['hasShinyVersion'] as bool,
    )
      ..isMaleCaptured = json['isMaleCaptured'] as bool
      ..isFemaleCaptured = json['isFemaleCaptured'] as bool
      ..isMaleShinyCaptured = json['isMaleShinyCaptured'] as bool
      ..isFemaleShinyCaptured = json['isFemaleShinyCaptured'] as bool
      ..isLuckyCaptured = json['isLuckyCaptured'] as bool;

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'genderRate': instance.genderRate,
      'category': instance.category,
      'artworks': instance.artworks
          .map((k, e) => MapEntry(_$ArtworkTypeEnumMap[k]!, e)),
      'hasShinyVersion': instance.hasShinyVersion,
      'isMaleCaptured': instance.isMaleCaptured,
      'isFemaleCaptured': instance.isFemaleCaptured,
      'isMaleShinyCaptured': instance.isMaleShinyCaptured,
      'isFemaleShinyCaptured': instance.isFemaleShinyCaptured,
      'isLuckyCaptured': instance.isLuckyCaptured,
    };

const _$ArtworkTypeEnumMap = {
  ArtworkType.male: 'male',
  ArtworkType.female: 'female',
  ArtworkType.maleshiny: 'maleshiny',
  ArtworkType.femaleshiny: 'femaleshiny',
  ArtworkType.alola: 'alola',
  ArtworkType.alolashiny: 'alolashiny',
};
