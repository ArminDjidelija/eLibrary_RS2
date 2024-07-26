import 'package:json_annotation/json_annotation.dart';
part 'pozajmica.g.dart';

@JsonSerializable()
class Pozajmica {
  int? pozajmicaId;
  int? citalacId;
  int? bibliotekaKnjigaId;
  String? datumPreuzimanja;
  String? preporuceniDatumVracanja;
  String? stvarniDatumVracanja;
  int? trajanje;
  bool? moguceProduziti;
  Pozajmica();
  factory Pozajmica.fromJson(Map<String, dynamic> json) =>
      _$PozajmicaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PozajmicaToJson(this);
}
