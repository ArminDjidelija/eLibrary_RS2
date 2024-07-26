// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija()
  ..rezervacijaId = (json['rezervacijaId'] as num?)?.toInt()
  ..citalacId = (json['citalacId'] as num?)?.toInt()
  ..bibliotekaKnjigaId = (json['bibliotekaKnjigaId'] as num?)?.toInt()
  ..datumKreiranja = json['datumKreiranja'] as String?
  ..odobreno = json['odobreno'] as bool?
  ..rokRezervacije = json['rokRezervacije'] as String?
  ..ponistena = json['ponistena'] as bool?;

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'citalacId': instance.citalacId,
      'bibliotekaKnjigaId': instance.bibliotekaKnjigaId,
      'datumKreiranja': instance.datumKreiranja,
      'odobreno': instance.odobreno,
      'rokRezervacije': instance.rokRezervacije,
      'ponistena': instance.ponistena,
    };
