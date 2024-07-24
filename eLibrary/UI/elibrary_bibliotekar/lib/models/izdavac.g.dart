// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izdavac.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Izdavac _$IzdavacFromJson(Map<String, dynamic> json) => Izdavac()
  ..izdavacId = (json['izdavacId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$IzdavacToJson(Izdavac instance) => <String, dynamic>{
      'izdavacId': instance.izdavacId,
      'naziv': instance.naziv,
    };
