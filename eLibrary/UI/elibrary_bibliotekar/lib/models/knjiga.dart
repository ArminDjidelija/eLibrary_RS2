import 'package:json_annotation/json_annotation.dart';
part 'knjiga.g.dart';

@JsonSerializable()
class Knjiga {
  int? knjigaId;
  String? naslov;
  String? isbn;
  String? slika;
  String? napomena;
  int? brojStranica;
  int? godinaIzdanja;
  int? brojIzdanja;
  int? izdavacId;
  int? jezikId;
  int? uvezId;
  int? vrsteGradeId;

  Knjiga({this.knjigaId, this.naslov, this.isbn});

  factory Knjiga.fromJson(Map<String, dynamic> json) => _$KnjigaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KnjigaToJson(this);
}

class KnjigaInsert {
  String? naslov;
  int? godinaIzdanja;
  int? brojIzdanja;
  int? brojStranica;
  String? isbn;
  String? napomena;
  String? slikaBase64;
  int? uvezId;
  int? izdavacId;
  int? vrsteGradeId;
  int? jezikId;
  List<int>? autori;
  List<int>? ciljneGrupe;
  List<int>? vrsteSadrzaja;
  KnjigaInsert({
    this.naslov,
    this.godinaIzdanja,
    this.brojIzdanja,
    this.brojStranica,
    this.isbn,
    this.napomena,
    this.uvezId,
    this.izdavacId,
    this.vrsteGradeId,
    this.jezikId,
    this.autori,
    this.ciljneGrupe,
    this.vrsteSadrzaja,
  });
}
