import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:json_annotation/json_annotation.dart';
part 'obavijest.g.dart';

@JsonSerializable()
class Obavijest {
  int? obavijestId;
  int? bibliotekaId;
  String? naslov;
  String? tekst;
  String? datum;
  int? citalacId;
  Biblioteka? biblioteka;
  Citalac? citalac;
  Obavijest();
  factory Obavijest.fromJson(Map<String, dynamic> json) =>
      _$ObavijestFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ObavijestToJson(this);
}
