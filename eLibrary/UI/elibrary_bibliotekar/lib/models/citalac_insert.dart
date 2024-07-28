import 'package:json_annotation/json_annotation.dart';
part 'citalac_insert.g.dart';

@JsonSerializable()
class CitalacInsert {
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  String? lozinka;
  String? lozinkaPotvrda;
  String? institucija;
  int? kantonId;
  CitalacInsert();

  factory CitalacInsert.fromJson(Map<String, dynamic> json) =>
      _$CitalacInsertFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CitalacInsertToJson(this);
}
