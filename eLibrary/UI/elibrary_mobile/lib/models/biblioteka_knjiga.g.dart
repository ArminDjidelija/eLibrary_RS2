// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biblioteka_knjiga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BibliotekaKnjiga _$BibliotekaKnjigaFromJson(Map<String, dynamic> json) =>
    BibliotekaKnjiga(
      bibliotekaKnjigaId: (json['bibliotekaKnjigaId'] as num?)?.toInt(),
      bibliotekaId: (json['bibliotekaId'] as num?)?.toInt(),
      knjigaId: (json['knjigaId'] as num?)?.toInt(),
    )
      ..brojKopija = (json['brojKopija'] as num?)?.toInt()
      ..datumDodavanja = json['datumDodavanja'] as String?
      ..lokacija = json['lokacija'] as String?
      ..dostupnoCitaonica = (json['dostupnoCitaonica'] as num?)?.toInt()
      ..dostupnoPozajmica = (json['dostupnoPozajmica'] as num?)?.toInt()
      ..trenutnoDostupno = (json['trenutnoDostupno'] as num?)?.toInt()
      ..biblioteka = json['biblioteka'] == null
          ? null
          : Biblioteka.fromJson(json['biblioteka'] as Map<String, dynamic>)
      ..knjiga = json['knjiga'] == null
          ? null
          : Knjiga.fromJson(json['knjiga'] as Map<String, dynamic>);

Map<String, dynamic> _$BibliotekaKnjigaToJson(BibliotekaKnjiga instance) =>
    <String, dynamic>{
      'bibliotekaKnjigaId': instance.bibliotekaKnjigaId,
      'bibliotekaId': instance.bibliotekaId,
      'knjigaId': instance.knjigaId,
      'brojKopija': instance.brojKopija,
      'datumDodavanja': instance.datumDodavanja,
      'lokacija': instance.lokacija,
      'dostupnoCitaonica': instance.dostupnoCitaonica,
      'dostupnoPozajmica': instance.dostupnoPozajmica,
      'trenutnoDostupno': instance.trenutnoDostupno,
      'biblioteka': instance.biblioteka,
      'knjiga': instance.knjiga,
    };
