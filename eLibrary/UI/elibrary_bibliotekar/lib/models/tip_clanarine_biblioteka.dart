import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tip_clanarine_biblioteka.g.dart';

@JsonSerializable()
class TipClanarineBiblioteka {
  int? tipClanarineBibliotekaId;
  String? naziv;
  int? trajanje;
  int? iznos;
  int? bibliotekaId;
  int? valutaId;
  Valuta? valuta;
  Biblioteka? biblioteka;

  TipClanarineBiblioteka();
  factory TipClanarineBiblioteka.fromJson(Map<String, dynamic> json) =>
      _$TipClanarineBibliotekaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TipClanarineBibliotekaToJson(this);
}
