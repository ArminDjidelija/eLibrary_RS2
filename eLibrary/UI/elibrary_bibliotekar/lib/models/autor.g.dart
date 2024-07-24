// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Autor _$AutorFromJson(Map<String, dynamic> json) => Autor()
  ..autorId = (json['autorId'] as num?)?.toInt()
  ..ime = json['ime'] as String?
  ..prezime = json['prezime'] as String?
  ..godinaRodjenja = (json['godinaRodjenja'] as num?)?.toInt();

Map<String, dynamic> _$AutorToJson(Autor instance) => <String, dynamic>{
      'autorId': instance.autorId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'godinaRodjenja': instance.godinaRodjenja,
    };
