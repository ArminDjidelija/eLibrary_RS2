import 'package:json_annotation/json_annotation.dart';
part 'knjiga.g.dart';

@JsonSerializable()
class Knjiga {
  int? knjigaId;
  String? naslov;
  String? isbn;
  String? slika;
  int? brojStranica;
  int? godinaIzdanja;
  int? brojIzdanja;

  Knjiga({this.knjigaId, this.naslov, this.isbn});

  factory Knjiga.fromJson(Map<String, dynamic> json) => _$KnjigaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KnjigaToJson(this);
}
