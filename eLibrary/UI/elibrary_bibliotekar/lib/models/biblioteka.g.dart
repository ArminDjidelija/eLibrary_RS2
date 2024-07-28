// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biblioteka.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biblioteka _$BibliotekaFromJson(Map<String, dynamic> json) => Biblioteka()
  ..bibliotekaId = (json['bibliotekaId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?
  ..adresa = json['adresa'] as String?
  ..opis = json['opis'] as String?
  ..web = json['web'] as String?
  ..telefon = json['telefon'] as String?
  ..mail = json['mail'] as String?
  ..kantonId = (json['kantonId'] as num?)?.toInt()
  ..kanton = json['kanton'] == null
      ? null
      : Kanton.fromJson(json['kanton'] as Map<String, dynamic>);

Map<String, dynamic> _$BibliotekaToJson(Biblioteka instance) =>
    <String, dynamic>{
      'bibliotekaId': instance.bibliotekaId,
      'naziv': instance.naziv,
      'adresa': instance.adresa,
      'opis': instance.opis,
      'web': instance.web,
      'telefon': instance.telefon,
      'mail': instance.mail,
      'kantonId': instance.kantonId,
      'kanton': instance.kanton,
    };
