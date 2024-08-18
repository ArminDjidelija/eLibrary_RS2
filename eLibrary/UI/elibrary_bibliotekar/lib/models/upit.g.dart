// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Upit _$UpitFromJson(Map<String, dynamic> json) => Upit()
  ..upitId = (json['upitId'] as num?)?.toInt()
  ..naslov = json['naslov'] as String?
  ..upit = json['upit'] as String?
  ..odgovor = json['odgovor'] as String?
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..citalac = json['citalac'] == null
      ? null
      : Citalac.fromJson(json['citalac'] as Map<String, dynamic>);

Map<String, dynamic> _$UpitToJson(Upit instance) => <String, dynamic>{
      'upitId': instance.upitId,
      'naslov': instance.naslov,
      'upit': instance.upit,
      'odgovor': instance.odgovor,
      'citalacId': instance.citalacId,
      'citalac': instance.citalac,
    };
