import 'package:json_annotation/json_annotation.dart';
part 'valuta.g.dart';

@JsonSerializable()
class Valuta {
  int? valutaId;
  String? naziv;
  String? skracenica;
  Valuta();
  factory Valuta.fromJson(Map<String, dynamic> json) => _$ValutaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ValutaToJson(this);
}
