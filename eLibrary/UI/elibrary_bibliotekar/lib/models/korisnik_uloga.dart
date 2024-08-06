import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:json_annotation/json_annotation.dart';
part 'korisnik_uloga.g.dart';

@JsonSerializable()
class KorisnikUloga {
  int? korisnikUlogaId;
  int? ulogaId;
  String? korisnikId;

  KorisnikUloga();

  factory KorisnikUloga.fromJson(Map<String, dynamic> json) =>
      _$KorisnikUlogaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisnikUlogaToJson(this);
}
