import 'package:elibrary_mobile/models/kanton.dart';
import 'package:json_annotation/json_annotation.dart';
part 'biblioteka.g.dart';

@JsonSerializable()
class Biblioteka {
  int? bibliotekaId;
  String? naziv;
  String? adresa;
  String? opis;
  String? web;
  String? telefon;
  String? mail;
  int? kantonId;
  Kanton? kanton;

  Biblioteka();

  factory Biblioteka.fromJson(Map<String, dynamic> json) =>
      _$BibliotekaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BibliotekaToJson(this);
}
