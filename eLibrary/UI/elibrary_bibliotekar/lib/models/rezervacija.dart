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
  bool? ponistena;
  Rezervacija();
  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
