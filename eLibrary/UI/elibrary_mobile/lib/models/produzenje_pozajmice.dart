import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:json_annotation/json_annotation.dart';
part 'produzenje_pozajmice.g.dart';

@JsonSerializable()
class ProduzenjePozajmice {
  int? produzenjePozajmiceId;
  int? produzenje;
  String? datumZahtjeva;
  String? noviRok;
  bool? odobreno;
  int? pozajmicaId;
  Pozajmica? pozajmica;

  ProduzenjePozajmice();

  factory ProduzenjePozajmice.fromJson(Map<String, dynamic> json) =>
      _$ProduzenjePozajmiceFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProduzenjePozajmiceToJson(this);
}
