import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:json_annotation/json_annotation.dart';
part 'kanton.g.dart';

@JsonSerializable()
class Kanton {
  int? kantonId;
  String? naziv;
  String? skracenica;
  List<Biblioteka>? bibliotekes;

  Kanton();

  factory Kanton.fromJson(Map<String, dynamic> json) => _$KantonFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KantonToJson(this);
}
