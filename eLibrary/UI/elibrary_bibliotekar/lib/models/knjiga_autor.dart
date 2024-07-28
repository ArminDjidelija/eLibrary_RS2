import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:json_annotation/json_annotation.dart';
part 'knjiga_autor.g.dart';

@JsonSerializable()
class KnjigaAutor {
  int? knjigaAutorId;
  int? autorId;
  int? knjigaId;
  Autor? autor;
  Knjiga? knjiga;

  KnjigaAutor();

  factory KnjigaAutor.fromJson(Map<String, dynamic> json) =>
      _$KnjigaAutorFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KnjigaAutorToJson(this);
}
