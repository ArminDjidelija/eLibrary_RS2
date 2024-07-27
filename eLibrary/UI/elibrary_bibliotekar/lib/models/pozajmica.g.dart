// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pozajmica.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pozajmica _$PozajmicaFromJson(Map<String, dynamic> json) => Pozajmica()
  ..pozajmicaId = (json['pozajmicaId'] as num?)?.toInt()
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..bibliotekaKnjigaId = (json['bibliotekaKnjigaId'] as num?)?.toInt()
  ..datumPreuzimanja = json['datumPreuzimanja'] as String?
  ..preporuceniDatumVracanja = json['preporuceniDatumVracanja'] as String?
  ..stvarniDatumVracanja = json['stvarniDatumVracanja'] as String?
  ..trajanje = (json['trajanje'] as num?)?.toInt()
  ..moguceProduziti = json['moguceProduziti'] as bool?
  ..citalac = json['citalac'] == null
      ? null
      : Citalac.fromJson(json['citalac'] as Map<String, dynamic>);

Map<String, dynamic> _$PozajmicaToJson(Pozajmica instance) => <String, dynamic>{
      'pozajmicaId': instance.pozajmicaId,
      'citalacId': instance.citalacId,
      'bibliotekaKnjigaId': instance.bibliotekaKnjigaId,
      'datumPreuzimanja': instance.datumPreuzimanja,
      'preporuceniDatumVracanja': instance.preporuceniDatumVracanja,
      'stvarniDatumVracanja': instance.stvarniDatumVracanja,
      'trajanje': instance.trajanje,
      'moguceProduziti': instance.moguceProduziti,
      'citalac': instance.citalac,
    };
