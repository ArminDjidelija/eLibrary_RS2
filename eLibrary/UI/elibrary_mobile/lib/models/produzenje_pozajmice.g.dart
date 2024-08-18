// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produzenje_pozajmice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProduzenjePozajmice _$ProduzenjePozajmiceFromJson(Map<String, dynamic> json) =>
    ProduzenjePozajmice()
      ..produzenjePozajmiceId = (json['produzenjePozajmiceId'] as num?)?.toInt()
      ..produzenje = (json['produzenje'] as num?)?.toInt()
      ..datumZahtjeva = json['datumZahtjeva'] as String?
      ..noviRok = json['noviRok'] as String?
      ..odobreno = json['odobreno'] as bool?
      ..pozajmicaId = (json['pozajmicaId'] as num?)?.toInt()
      ..pozajmica = json['pozajmica'] == null
          ? null
          : Pozajmica.fromJson(json['pozajmica'] as Map<String, dynamic>);

Map<String, dynamic> _$ProduzenjePozajmiceToJson(
        ProduzenjePozajmice instance) =>
    <String, dynamic>{
      'produzenjePozajmiceId': instance.produzenjePozajmiceId,
      'produzenje': instance.produzenje,
      'datumZahtjeva': instance.datumZahtjeva,
      'noviRok': instance.noviRok,
      'odobreno': instance.odobreno,
      'pozajmicaId': instance.pozajmicaId,
      'pozajmica': instance.pozajmica,
    };
