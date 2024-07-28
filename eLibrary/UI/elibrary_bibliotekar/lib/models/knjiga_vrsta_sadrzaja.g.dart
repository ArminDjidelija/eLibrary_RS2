// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knjiga_vrsta_sadrzaja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnjigaVrstaSadrzaja _$KnjigaVrstaSadrzajaFromJson(Map<String, dynamic> json) =>
    KnjigaVrstaSadrzaja()
      ..knjigaVrstaSadrzajaId = (json['knjigaVrstaSadrzajaId'] as num?)?.toInt()
      ..vrstaSadrzajaId = (json['vrstaSadrzajaId'] as num?)?.toInt()
      ..knjigaId = (json['knjigaId'] as num?)?.toInt()
      ..knjiga = json['knjiga'] == null
          ? null
          : Knjiga.fromJson(json['knjiga'] as Map<String, dynamic>)
      ..vrstaSadrzaja = json['vrstaSadrzaja'] == null
          ? null
          : VrstaSadrzaja.fromJson(
              json['vrstaSadrzaja'] as Map<String, dynamic>);

Map<String, dynamic> _$KnjigaVrstaSadrzajaToJson(
        KnjigaVrstaSadrzaja instance) =>
    <String, dynamic>{
      'knjigaVrstaSadrzajaId': instance.knjigaVrstaSadrzajaId,
      'vrstaSadrzajaId': instance.vrstaSadrzajaId,
      'knjigaId': instance.knjigaId,
      'knjiga': instance.knjiga,
      'vrstaSadrzaja': instance.vrstaSadrzaja,
    };
