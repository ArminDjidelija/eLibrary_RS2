// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knjiga_autor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnjigaAutor _$KnjigaAutorFromJson(Map<String, dynamic> json) => KnjigaAutor()
  ..knjigaAutorId = (json['knjigaAutorId'] as num?)?.toInt()
  ..autorId = (json['autorId'] as num?)?.toInt()
  ..knjigaId = (json['knjigaId'] as num?)?.toInt()
  ..autor = json['autor'] == null
      ? null
      : Autor.fromJson(json['autor'] as Map<String, dynamic>)
  ..knjiga = json['knjiga'] == null
      ? null
      : Knjiga.fromJson(json['knjiga'] as Map<String, dynamic>);

Map<String, dynamic> _$KnjigaAutorToJson(KnjigaAutor instance) =>
    <String, dynamic>{
      'knjigaAutorId': instance.knjigaAutorId,
      'autorId': instance.autorId,
      'knjigaId': instance.knjigaId,
      'autor': instance.autor,
      'knjiga': instance.knjiga,
    };
