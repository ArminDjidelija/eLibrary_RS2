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
      ..napomena = json['napomena'] as String?
      ..brojStranica = (json['brojStranica'] as num?)?.toInt()
      ..godinaIzdanja = (json['godinaIzdanja'] as num?)?.toInt()
      ..brojIzdanja = (json['brojIzdanja'] as num?)?.toInt()
      ..izdavacId = (json['izdavacId'] as num?)?.toInt()
      ..jezikId = (json['jezikId'] as num?)?.toInt()
      ..uvezId = (json['uvezId'] as num?)?.toInt()
      ..vrsteGradeId = (json['vrsteGradeId'] as num?)?.toInt()
      ..uvez = json['uvez'] == null
          ? null
          : Uvez.fromJson(json['uvez'] as Map<String, dynamic>)
      ..jezik = json['jezik'] == null
          ? null
          : Jezik.fromJson(json['jezik'] as Map<String, dynamic>)
      ..izdavac = json['izdavac'] == null
          ? null
          : Izdavac.fromJson(json['izdavac'] as Map<String, dynamic>)
      ..bibliotekaKnjiges = (json['bibliotekaKnjiges'] as List<dynamic>?)
          ?.map((e) => BibliotekaKnjiga.fromJson(e as Map<String, dynamic>))
          .toList()
      ..knjigaAutoris = (json['knjigaAutoris'] as List<dynamic>?)
          ?.map((e) => KnjigaAutor.fromJson(e as Map<String, dynamic>))
          .toList()
      ..knjigaCiljneGrupes = (json['knjigaCiljneGrupes'] as List<dynamic>?)
          ?.map((e) => KnjigaCiljnaGrupa.fromJson(e as Map<String, dynamic>))
          .toList()
      ..knjigaVrsteSadrzajas = (json['knjigaVrsteSadrzajas'] as List<dynamic>?)
          ?.map((e) => KnjigaVrstaSadrzaja.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KnjigaToJson(Knjiga instance) => <String, dynamic>{
      'knjigaId': instance.knjigaId,
      'naslov': instance.naslov,
      'isbn': instance.isbn,
      'slika': instance.slika,
      'napomena': instance.napomena,
      'brojStranica': instance.brojStranica,
      'godinaIzdanja': instance.godinaIzdanja,
      'brojIzdanja': instance.brojIzdanja,
      'izdavacId': instance.izdavacId,
      'jezikId': instance.jezikId,
      'uvezId': instance.uvezId,
      'vrsteGradeId': instance.vrsteGradeId,
      'uvez': instance.uvez,
      'jezik': instance.jezik,
      'izdavac': instance.izdavac,
      'bibliotekaKnjiges': instance.bibliotekaKnjiges,
      'knjigaAutoris': instance.knjigaAutoris,
      'knjigaCiljneGrupes': instance.knjigaCiljneGrupes,
      'knjigaVrsteSadrzajas': instance.knjigaVrsteSadrzajas,
    };
