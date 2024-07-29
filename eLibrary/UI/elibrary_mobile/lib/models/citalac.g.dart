// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citalac.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Citalac _$CitalacFromJson(Map<String, dynamic> json) => Citalac()
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..ime = json['ime'] as String?
  ..prezime = json['prezime'] as String?
  ..email = json['email'] as String?
  ..telefon = json['telefon'] as String?
  ..korisnickoIme = json['korisnickoIme'] as String?
  ..status = json['status'] as bool?
  ..institucija = json['institucija'] as String?
  ..datumRegistracije = json['datumRegistracije'] as String?
  ..kantonId = (json['kantonId'] as num?)?.toInt()
  ..kanton = json['kanton'] == null
      ? null
      : Kanton.fromJson(json['kanton'] as Map<String, dynamic>);

Map<String, dynamic> _$CitalacToJson(Citalac instance) => <String, dynamic>{
      'citalacId': instance.citalacId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnickoIme': instance.korisnickoIme,
      'status': instance.status,
      'institucija': instance.institucija,
      'datumRegistracije': instance.datumRegistracije,
      'kantonId': instance.kantonId,
      'kanton': instance.kanton,
    };
