import 'package:elibrary_bibliotekar/models/kanton.dart';
import 'package:json_annotation/json_annotation.dart';
part 'citalac.g.dart';

@JsonSerializable()
class Citalac {
  int? citalacId;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  bool? status;
  String? institucija;
  String? datumRegistracije;
  int? kantonId;
  // List<Null>? bibliotekaCitaociZabranes;
  // List<Null>? clanarines;
  Kanton? kanton;
  // List<Null>? korisnikSacuvanaKnjigas;
  // List<Null>? obavijestis;
  // List<Null>? pozajmices;
  // List<Null>? rezervacijes;
  // List<Null>? upitis;
  // List<Null>? uplates;
  Citalac();

  factory Citalac.fromJson(Map<String, dynamic> json) =>
      _$CitalacFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CitalacToJson(this);
}
