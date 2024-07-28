// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrsta_sadrzaja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VrstaSadrzaja _$VrstaSadrzajaFromJson(Map<String, dynamic> json) =>
    VrstaSadrzaja()
      ..vrstaSadrzajaId = (json['vrstaSadrzajaId'] as num?)?.toInt()
      ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$VrstaSadrzajaToJson(VrstaSadrzaja instance) =>
    <String, dynamic>{
      'vrstaSadrzajaId': instance.vrstaSadrzajaId,
      'naziv': instance.naziv,
    };
