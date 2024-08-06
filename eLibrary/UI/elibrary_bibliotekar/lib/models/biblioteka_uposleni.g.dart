// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biblioteka_uposleni.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BibliotekaUposleni _$BibliotekaUposleniFromJson(Map<String, dynamic> json) =>
    BibliotekaUposleni()
      ..korisnikId = (json['korisnikId'] as num?)?.toInt()
      ..bibliotekaId = (json['bibliotekaId'] as num?)?.toInt()
      ..bibliotekaUposleniId = (json['bibliotekaUposleniId'] as num?)?.toInt()
      ..datumUposlenja = json['datumUposlenja'] as String?
      ..biblioteka = json['biblioteka'] == null
          ? null
          : Biblioteka.fromJson(json['biblioteka'] as Map<String, dynamic>)
      ..korisnik = json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>);

Map<String, dynamic> _$BibliotekaUposleniToJson(BibliotekaUposleni instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'bibliotekaId': instance.bibliotekaId,
      'bibliotekaUposleniId': instance.bibliotekaUposleniId,
      'datumUposlenja': instance.datumUposlenja,
      'biblioteka': instance.biblioteka,
      'korisnik': instance.korisnik,
    };
