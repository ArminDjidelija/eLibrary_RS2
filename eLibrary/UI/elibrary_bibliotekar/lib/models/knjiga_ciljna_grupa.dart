import 'package:elibrary_bibliotekar/models/ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/vrsta_sadrzaja.dart';
import 'package:json_annotation/json_annotation.dart';

part 'knjiga_ciljna_grupa.g.dart';

@JsonSerializable()
class KnjigaCiljnaGrupa {
  int? knjigaCiljnaGrupaId;
  int? ciljnaGrupaId;
  int? knjigaId;
  CiljnaGrupa? ciljnaGrupa;
  Knjiga? knjiga;
  KnjigaCiljnaGrupa();

  factory KnjigaCiljnaGrupa.fromJson(Map<String, dynamic> json) =>
      _$KnjigaCiljnaGrupaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KnjigaCiljnaGrupaToJson(this);
}
