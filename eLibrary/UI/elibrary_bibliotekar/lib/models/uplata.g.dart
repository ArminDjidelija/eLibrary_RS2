// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uplata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uplata _$UplataFromJson(Map<String, dynamic> json) => Uplata()
  ..uplataId = (json['uplataId'] as num?)?.toInt()
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..bibliotekaId = (json['bibliotekaId'] as num?)?.toInt()
  ..iznos = (json['iznos'] as num?)?.toInt()
  ..datumUplate = json['datumUplate'] as String?
  ..tipUplateId = (json['tipUplateId'] as num?)?.toInt()
  ..valutaId = (json['valutaId'] as num?)?.toInt()
  ..biblioteka = json['biblioteka'] == null
      ? null
      : Biblioteka.fromJson(json['biblioteka'] as Map<String, dynamic>)
  ..citalac = json['citalac'] == null
      ? null
      : Citalac.fromJson(json['citalac'] as Map<String, dynamic>)
  ..tipUplate = json['tipUplate'] == null
      ? null
      : TipUplate.fromJson(json['tipUplate'] as Map<String, dynamic>)
  ..valuta = json['valuta'] == null
      ? null
      : Valuta.fromJson(json['valuta'] as Map<String, dynamic>);

Map<String, dynamic> _$UplataToJson(Uplata instance) => <String, dynamic>{
      'uplataId': instance.uplataId,
      'citalacId': instance.citalacId,
      'bibliotekaId': instance.bibliotekaId,
      'iznos': instance.iznos,
      'datumUplate': instance.datumUplate,
      'tipUplateId': instance.tipUplateId,
      'valutaId': instance.valutaId,
      'biblioteka': instance.biblioteka,
      'citalac': instance.citalac,
      'tipUplate': instance.tipUplate,
      'valuta': instance.valuta,
    };
