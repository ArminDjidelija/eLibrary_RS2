// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citalac_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CitalacInsert _$CitalacInsertFromJson(Map<String, dynamic> json) =>
    CitalacInsert()
      ..ime = json['ime'] as String?
      ..prezime = json['prezime'] as String?
      ..email = json['email'] as String?
      ..telefon = json['telefon'] as String?
      ..korisnickoIme = json['korisnickoIme'] as String?
      ..lozinka = json['lozinka'] as String?
      ..lozinkaPotvrda = json['lozinkaPotvrda'] as String?
      ..institucija = json['institucija'] as String?
      ..kantonId = (json['kantonId'] as num?)?.toInt();

Map<String, dynamic> _$CitalacInsertToJson(CitalacInsert instance) =>
    <String, dynamic>{
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnickoIme': instance.korisnickoIme,
      'lozinka': instance.lozinka,
      'lozinkaPotvrda': instance.lozinkaPotvrda,
      'institucija': instance.institucija,
      'kantonId': instance.kantonId,
    };
