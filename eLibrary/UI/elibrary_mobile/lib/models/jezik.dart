import 'package:json_annotation/json_annotation.dart';
part 'jezik.g.dart';

@JsonSerializable()
class Jezik {
  int? jezikId;
  String? naziv;
  Jezik();
  factory Jezik.fromJson(Map<String, dynamic> json) => _$JezikFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$JezikToJson(this);
}
