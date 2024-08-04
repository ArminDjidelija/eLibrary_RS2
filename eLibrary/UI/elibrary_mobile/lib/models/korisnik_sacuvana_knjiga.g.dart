// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik_sacuvana_knjiga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikSacuvanaKnjiga _$KorisnikSacuvanaKnjigaFromJson(
        Map<String, dynamic> json) =>
    KorisnikSacuvanaKnjiga()
      ..korisnikSacuvanaKnjigaId =
          (json['korisnikSacuvanaKnjigaId'] as num?)?.toInt()
      ..citalacId = (json['citalacId'] as num?)?.toInt()
      ..knjigaId = (json['knjigaId'] as num?)?.toInt()
      ..citalac = json['citalac'] == null
          ? null
          : Citalac.fromJson(json['citalac'] as Map<String, dynamic>)
      ..knjiga = json['knjiga'] == null
          ? null
          : Knjiga.fromJson(json['knjiga'] as Map<String, dynamic>);

Map<String, dynamic> _$KorisnikSacuvanaKnjigaToJson(
        KorisnikSacuvanaKnjiga instance) =>
    <String, dynamic>{
      'korisnikSacuvanaKnjigaId': instance.korisnikSacuvanaKnjigaId,
      'citalacId': instance.citalacId,
      'knjigaId': instance.knjigaId,
      'citalac': instance.citalac,
      'knjiga': instance.knjiga,
    };
