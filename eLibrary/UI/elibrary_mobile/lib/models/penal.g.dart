// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Penal _$PenalFromJson(Map<String, dynamic> json) => Penal()
  ..penalId = (json['penalId'] as num?)?.toInt()
  ..pozajmicaId = (json['pozajmicaId'] as num?)?.toInt()
  ..opis = json['opis'] as String?
  ..iznos = (json['iznos'] as num?)?.toInt()
  ..uplataId = (json['uplataId'] as num?)?.toInt()
  ..pozajmica = json['pozajmica'] == null
      ? null
      : Pozajmica.fromJson(json['pozajmica'] as Map<String, dynamic>)
  ..uplata = json['uplata'] == null
      ? null
      : Uplata.fromJson(json['uplata'] as Map<String, dynamic>);

Map<String, dynamic> _$PenalToJson(Penal instance) => <String, dynamic>{
      'penalId': instance.penalId,
      'pozajmicaId': instance.pozajmicaId,
      'opis': instance.opis,
      'iznos': instance.iznos,
      'uplataId': instance.uplataId,
      'pozajmica': instance.pozajmica,
      'uplata': instance.uplata,
    };
