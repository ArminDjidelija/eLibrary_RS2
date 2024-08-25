import 'package:elibrary_mobile/models/citalac.dart';
import 'package:json_annotation/json_annotation.dart';
part 'upit.g.dart';

@JsonSerializable()
class Upit {
  int? upitId;
  String? naslov;
  String? upit;
  String? odgovor;
  int? citalacId;
  Citalac? citalac;

  Upit();

  factory Upit.fromJson(Map<String, dynamic> json) => _$UpitFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UpitToJson(this);
}
