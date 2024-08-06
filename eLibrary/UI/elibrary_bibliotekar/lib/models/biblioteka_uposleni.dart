import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/korisnik.dart';
import 'package:elibrary_bibliotekar/models/tip_uplate.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'biblioteka_uposleni.g.dart';

@JsonSerializable()
class BibliotekaUposleni {
  int? korisnikId;
  int? bibliotekaId;
  int? bibliotekaUposleniId;
  String? datumUposlenja;
  Biblioteka? biblioteka;
  Korisnik? korisnik;

  BibliotekaUposleni();

  factory BibliotekaUposleni.fromJson(Map<String, dynamic> json) =>
      _$BibliotekaUposleniFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BibliotekaUposleniToJson(this);
}
