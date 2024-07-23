// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knjiga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Knjiga _$KnjigaFromJson(Map<String, dynamic> json) => Knjiga(
      knjigaId: (json['knjigaId'] as num?)?.toInt(),
      naslov: json['naslov'] as String?,
      isbn: json['isbn'] as String?,
    )
      ..slika = json['slika'] as String?
      ..brojStranica = (json['brojStranica'] as num?)?.toInt()
      ..godinaIzdanja = (json['godinaIzdanja'] as num?)?.toInt()
      ..brojIzdanja = (json['brojIzdanja'] as num?)?.toInt();

Map<String, dynamic> _$KnjigaToJson(Knjiga instance) => <String, dynamic>{
      'knjigaId': instance.knjigaId,
      'naslov': instance.naslov,
      'isbn': instance.isbn,
      'slika': instance.slika,
      'brojStranica': instance.brojStranica,
      'godinaIzdanja': instance.godinaIzdanja,
      'brojIzdanja': instance.brojIzdanja,
    };
