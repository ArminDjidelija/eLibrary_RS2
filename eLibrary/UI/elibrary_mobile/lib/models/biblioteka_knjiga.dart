import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:json_annotation/json_annotation.dart';
part 'biblioteka_knjiga.g.dart';

@JsonSerializable()
class BibliotekaKnjiga {
  int? bibliotekaKnjigaId;
  int? bibliotekaId;
  int? knjigaId;
  int? brojKopija;
  String? datumDodavanja;
  String? lokacija;
  int? dostupnoCitaonica;
  int? dostupnoPozajmica;
  int? trenutnoDostupno;
  Biblioteka? biblioteka;
  Knjiga? knjiga;
  // List<Pozajmices>? pozajmices;
  // List<Rezervacijes>? rezervacijes;

  BibliotekaKnjiga({this.bibliotekaKnjigaId, this.bibliotekaId, this.knjigaId});

  factory BibliotekaKnjiga.fromJson(Map<String, dynamic> json) =>
      _$BibliotekaKnjigaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BibliotekaKnjigaToJson(this);
}
