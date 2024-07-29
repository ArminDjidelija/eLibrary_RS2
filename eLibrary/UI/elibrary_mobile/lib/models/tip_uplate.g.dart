// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_uplate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipUplate _$TipUplateFromJson(Map<String, dynamic> json) => TipUplate()
  ..tipUplateId = (json['tipUplateId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$TipUplateToJson(TipUplate instance) => <String, dynamic>{
      'tipUplateId': instance.tipUplateId,
      'naziv': instance.naziv,
    };
