// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanton.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kanton _$KantonFromJson(Map<String, dynamic> json) => Kanton()
  ..kantonId = (json['kantonId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?
  ..skracenica = json['skracenica'] as String?
  ..bibliotekes = (json['bibliotekes'] as List<dynamic>?)
      ?.map((e) => Biblioteka.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KantonToJson(Kanton instance) => <String, dynamic>{
      'kantonId': instance.kantonId,
      'naziv': instance.naziv,
      'skracenica': instance.skracenica,
      'bibliotekes': instance.bibliotekes,
    };
