// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knjiga_ciljna_grupa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnjigaCiljnaGrupa _$KnjigaCiljnaGrupaFromJson(Map<String, dynamic> json) =>
    KnjigaCiljnaGrupa()
      ..knjigaCiljnaGrupaId = (json['knjigaCiljnaGrupaId'] as num?)?.toInt()
      ..ciljnaGrupaId = (json['ciljnaGrupaId'] as num?)?.toInt()
      ..knjigaId = (json['knjigaId'] as num?)?.toInt()
      ..ciljnaGrupa = json['ciljnaGrupa'] == null
          ? null
          : CiljnaGrupa.fromJson(json['ciljnaGrupa'] as Map<String, dynamic>)
      ..knjiga = json['knjiga'] == null
          ? null
          : Knjiga.fromJson(json['knjiga'] as Map<String, dynamic>);

Map<String, dynamic> _$KnjigaCiljnaGrupaToJson(KnjigaCiljnaGrupa instance) =>
    <String, dynamic>{
      'knjigaCiljnaGrupaId': instance.knjigaCiljnaGrupaId,
      'ciljnaGrupaId': instance.ciljnaGrupaId,
      'knjigaId': instance.knjigaId,
      'ciljnaGrupa': instance.ciljnaGrupa,
      'knjiga': instance.knjiga,
    };
