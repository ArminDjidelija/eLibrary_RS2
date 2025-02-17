import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'penal.g.dart';

@JsonSerializable()
class Penal {
  int? penalId;
  int? pozajmicaId;
  String? opis;
  int? iznos;
  int? uplataId;
  Pozajmica? pozajmica;
  Uplata? uplata;

  Penal();

  factory Penal.fromJson(Map<String, dynamic> json) => _$PenalFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PenalToJson(this);
}
