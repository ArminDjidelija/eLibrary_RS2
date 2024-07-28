// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clanarina.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clanarina _$ClanarinaFromJson(Map<String, dynamic> json) => Clanarina()
  ..clanarinaId = (json['clanarinaId'] as num?)?.toInt()
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..bibliotekaId = (json['bibliotekaId'] as num?)?.toInt()
  ..uplateId = (json['uplateId'] as num?)?.toInt()
  ..tipClanarineBibliotekaId =
      (json['tipClanarineBibliotekaId'] as num?)?.toInt()
  ..iznos = (json['iznos'] as num?)?.toInt()
  ..pocetak = json['pocetak'] as String?
  ..kraj = json['kraj'] as String?
  ..biblioteka = json['biblioteka'] == null
      ? null
      : Biblioteka.fromJson(json['biblioteka'] as Map<String, dynamic>)
  ..citalac = json['citalac'] == null
      ? null
      : Citalac.fromJson(json['citalac'] as Map<String, dynamic>)
  ..tipClanarineBiblioteka = json['tipClanarineBiblioteka'] == null
      ? null
      : TipClanarineBiblioteka.fromJson(
          json['tipClanarineBiblioteka'] as Map<String, dynamic>)
  ..uplate = json['uplate'] == null
      ? null
      : Uplata.fromJson(json['uplate'] as Map<String, dynamic>);

Map<String, dynamic> _$ClanarinaToJson(Clanarina instance) => <String, dynamic>{
      'clanarinaId': instance.clanarinaId,
      'citalacId': instance.citalacId,
      'bibliotekaId': instance.bibliotekaId,
      'uplateId': instance.uplateId,
      'tipClanarineBibliotekaId': instance.tipClanarineBibliotekaId,
      'iznos': instance.iznos,
      'pocetak': instance.pocetak,
      'kraj': instance.kraj,
      'biblioteka': instance.biblioteka,
      'citalac': instance.citalac,
      'tipClanarineBiblioteka': instance.tipClanarineBiblioteka,
      'uplate': instance.uplate,
    };
