// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_clanarine_biblioteka.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipClanarineBiblioteka _$TipClanarineBibliotekaFromJson(
        Map<String, dynamic> json) =>
    TipClanarineBiblioteka()
      ..tipClanarineBibliotekaId =
          (json['tipClanarineBibliotekaId'] as num?)?.toInt()
      ..naziv = json['naziv'] as String?
      ..trajanje = (json['trajanje'] as num?)?.toInt()
      ..iznos = (json['iznos'] as num?)?.toDouble()
      ..bibliotekaId = (json['bibliotekaId'] as num?)?.toInt()
      ..valutaId = (json['valutaId'] as num?)?.toInt()
      ..valuta = json['valuta'] == null
          ? null
          : Valuta.fromJson(json['valuta'] as Map<String, dynamic>)
      ..biblioteka = json['biblioteka'] == null
          ? null
          : Biblioteka.fromJson(json['biblioteka'] as Map<String, dynamic>);

Map<String, dynamic> _$TipClanarineBibliotekaToJson(
        TipClanarineBiblioteka instance) =>
    <String, dynamic>{
      'tipClanarineBibliotekaId': instance.tipClanarineBibliotekaId,
      'naziv': instance.naziv,
      'trajanje': instance.trajanje,
      'iznos': instance.iznos,
      'bibliotekaId': instance.bibliotekaId,
      'valutaId': instance.valutaId,
      'valuta': instance.valuta,
      'biblioteka': instance.biblioteka,
    };
