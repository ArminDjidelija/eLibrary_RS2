import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_mobile/models/uplata.dart';
import 'package:json_annotation/json_annotation.dart';
part 'clanarina.g.dart';

@JsonSerializable()
class Clanarina {
  int? clanarinaId;
  int? citalacId;
  int? bibliotekaId;
  int? uplateId;
  int? tipClanarineBibliotekaId;
  double? iznos;
  String? pocetak;
  String? kraj;
  Biblioteka? biblioteka;
  Citalac? citalac;
  TipClanarineBiblioteka? tipClanarineBiblioteka;
  Uplata? uplate;

  Clanarina();

  factory Clanarina.fromJson(Map<String, dynamic> json) =>
      _$ClanarinaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ClanarinaToJson(this);
}
