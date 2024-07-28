import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/tip_uplate.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'uplata.g.dart';

@JsonSerializable()
class Uplata {
  int? uplataId;
  int? citalacId;
  int? bibliotekaId;
  int? iznos;
  String? datumUplate;
  int? tipUplateId;
  int? valutaId;
  Biblioteka? biblioteka;
  Citalac? citalac;
  // List<Clanarines>? clanarines;
  // List<Penalis>? penalis;
  TipUplate? tipUplate;
  Valuta? valuta;
  Uplata();
  factory Uplata.fromJson(Map<String, dynamic> json) => _$UplataFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UplataToJson(this);
}
