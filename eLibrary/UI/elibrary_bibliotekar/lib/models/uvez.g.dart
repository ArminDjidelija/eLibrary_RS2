// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uvez.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uvez _$UvezFromJson(Map<String, dynamic> json) => Uvez()
  ..uvezId = (json['uvezId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$UvezToJson(Uvez instance) => <String, dynamic>{
      'uvezId': instance.uvezId,
      'naziv': instance.naziv,
    };
