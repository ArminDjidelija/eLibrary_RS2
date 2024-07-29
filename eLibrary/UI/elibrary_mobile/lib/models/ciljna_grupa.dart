import 'package:json_annotation/json_annotation.dart';
part 'ciljna_grupa.g.dart';

@JsonSerializable()
class CiljnaGrupa {
  int? ciljnaGrupaId;
  String? naziv;

  CiljnaGrupa();

  factory CiljnaGrupa.fromJson(Map<String, dynamic> json) =>
      _$CiljnaGrupaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CiljnaGrupaToJson(this);
}
