import 'package:elibrary_mobile/models/biblioteka_knjiga.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:json_annotation/json_annotation.dart';
part 'rezervacija.g.dart';

@JsonSerializable()
class Rezervacija {
  int? rezervacijaId;
  int? citalacId;
  int? bibliotekaKnjigaId;
  String? datumKreiranja;
  bool? odobreno;
  String? rokRezervacije;
  String? state;
  bool? ponistena;
  Citalac? citalac;
  BibliotekaKnjiga? bibliotekaKnjiga;
  Rezervacija();
  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
