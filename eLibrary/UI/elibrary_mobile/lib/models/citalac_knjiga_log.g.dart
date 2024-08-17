// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citalac_knjiga_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CitalacKnjigaLog _$CitalacKnjigaLogFromJson(Map<String, dynamic> json) =>
    CitalacKnjigaLog()
      ..citalacKnjigaLogId = (json['citalacKnjigaLogId'] as num?)?.toInt()
      ..citalacId = (json['citalacId'] as num?)?.toInt()
      ..knjigaId = (json['knjigaId'] as num?)?.toInt()
      ..citalac = json['citalac'] == null
          ? null
          : Citalac.fromJson(json['citalac'] as Map<String, dynamic>)
      ..knjiga = json['knjiga'] == null
          ? null
          : Knjiga.fromJson(json['knjiga'] as Map<String, dynamic>);

Map<String, dynamic> _$CitalacKnjigaLogToJson(CitalacKnjigaLog instance) =>
    <String, dynamic>{
      'citalacKnjigaLogId': instance.citalacKnjigaLogId,
      'citalacId': instance.citalacId,
      'knjigaId': instance.knjigaId,
      'citalac': instance.citalac,
      'knjiga': instance.knjiga,
    };
