import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_uposleni.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/korisnik_uloga.dart';
import 'package:elibrary_bibliotekar/models/tip_uplate.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  bool? status;
  int? bibliotekaId;
  List<BibliotekaUposleni>? bibliotekaUposlenis;
  List<KorisnikUloga>? korisniciUloges;

  Korisnik();

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
