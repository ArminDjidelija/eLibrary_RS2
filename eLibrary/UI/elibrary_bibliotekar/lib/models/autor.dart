import 'package:json_annotation/json_annotation.dart';
part 'autor.g.dart';

@JsonSerializable()
class Autor {
  int? autorId;
  String? ime;
  String? prezime;
  int? godinaRodjenja;
  Autor();

  factory Autor.fromJson(Map<String, dynamic> json) => _$AutorFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AutorToJson(this);
}
