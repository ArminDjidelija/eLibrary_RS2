// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jezik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jezik _$JezikFromJson(Map<String, dynamic> json) => Jezik()
  ..jezikId = (json['jezikId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$JezikToJson(Jezik instance) => <String, dynamic>{
      'jezikId': instance.jezikId,
      'naziv': instance.naziv,
    };
