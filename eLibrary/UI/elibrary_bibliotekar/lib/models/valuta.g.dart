// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valuta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Valuta _$ValutaFromJson(Map<String, dynamic> json) => Valuta()
  ..valutaId = (json['valutaId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?
  ..skracenica = json['skracenica'] as String?;

Map<String, dynamic> _$ValutaToJson(Valuta instance) => <String, dynamic>{
      'valutaId': instance.valutaId,
      'naziv': instance.naziv,
      'skracenica': instance.skracenica,
    };
