// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pozajmica_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PozajmicaInfo _$PozajmicaInfoFromJson(Map<String, dynamic> json) =>
    PozajmicaInfo()
      ..mjesecInt = (json['mjesecInt'] as num?)?.toInt()
      ..rb = (json['rb'] as num?)?.toInt()
      ..mjesecString = json['mjesecString'] as String?
      ..brojPozajmica = (json['brojPozajmica'] as num?)?.toInt();

Map<String, dynamic> _$PozajmicaInfoToJson(PozajmicaInfo instance) =>
    <String, dynamic>{
      'mjesecInt': instance.mjesecInt,
      'rb': instance.rb,
      'mjesecString': instance.mjesecString,
      'brojPozajmica': instance.brojPozajmica,
    };
