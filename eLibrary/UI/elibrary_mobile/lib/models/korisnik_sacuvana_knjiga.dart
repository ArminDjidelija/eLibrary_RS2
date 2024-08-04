import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:json_annotation/json_annotation.dart';

part 'korisnik_sacuvana_knjiga.g.dart';

@JsonSerializable()
class KorisnikSacuvanaKnjiga {
  int? korisnikSacuvanaKnjigaId;
  int? citalacId;
  int? knjigaId;
  Citalac? citalac;
  Knjiga? knjiga;

  KorisnikSacuvanaKnjiga();

  factory KorisnikSacuvanaKnjiga.fromJson(Map<String, dynamic> json) =>
      _$KorisnikSacuvanaKnjigaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisnikSacuvanaKnjigaToJson(this);
}
