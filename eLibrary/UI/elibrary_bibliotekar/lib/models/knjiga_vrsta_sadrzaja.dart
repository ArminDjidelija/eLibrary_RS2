import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/vrsta_sadrzaja.dart';
import 'package:json_annotation/json_annotation.dart';
part 'knjiga_vrsta_sadrzaja.g.dart';

@JsonSerializable()
class KnjigaVrstaSadrzaja {
  int? knjigaVrstaSadrzajaId;
  int? vrstaSadrzajaId;
  int? knjigaId;
  Knjiga? knjiga;
  VrstaSadrzaja? vrstaSadrzaja;
  KnjigaVrstaSadrzaja();

  factory KnjigaVrstaSadrzaja.fromJson(Map<String, dynamic> json) =>
      _$KnjigaVrstaSadrzajaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KnjigaVrstaSadrzajaToJson(this);
}
