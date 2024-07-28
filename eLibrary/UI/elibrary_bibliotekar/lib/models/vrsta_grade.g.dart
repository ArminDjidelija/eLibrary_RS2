// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrsta_grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VrstaGrade _$VrstaGradeFromJson(Map<String, dynamic> json) => VrstaGrade()
  ..vrstaGradeId = (json['vrstaGradeId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$VrstaGradeToJson(VrstaGrade instance) =>
    <String, dynamic>{
      'vrstaGradeId': instance.vrstaGradeId,
      'naziv': instance.naziv,
    };
