// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obavijest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Obavijest _$ObavijestFromJson(Map<String, dynamic> json) => Obavijest()
  ..obavijestId = (json['obavijestId'] as num?)?.toInt()
  ..bibliotekaId = (json['bibliotekaId'] as num?)?.toInt()
  ..naslov = json['naslov'] as String?
  ..tekst = json['tekst'] as String?
  ..datum = json['datum'] as String?
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..biblioteka = json['biblioteka'] == null
      ? null
      : Biblioteka.fromJson(json['biblioteka'] as Map<String, dynamic>)
  ..citalac = json['citalac'] == null
      ? null
      : Citalac.fromJson(json['citalac'] as Map<String, dynamic>);

Map<String, dynamic> _$ObavijestToJson(Obavijest instance) => <String, dynamic>{
      'obavijestId': instance.obavijestId,
      'bibliotekaId': instance.bibliotekaId,
      'naslov': instance.naslov,
      'tekst': instance.tekst,
      'datum': instance.datum,
      'citalacId': instance.citalacId,
      'biblioteka': instance.biblioteka,
      'citalac': instance.citalac,
    };
