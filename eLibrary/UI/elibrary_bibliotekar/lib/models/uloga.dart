import 'package:json_annotation/json_annotation.dart';
part 'uloga.g.dart';

@JsonSerializable()
class Uloga {
  int? ulogaId;
  String? naziv;
  Uloga();

  factory Uloga.fromJson(Map<String, dynamic> json) => _$UlogaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UlogaToJson(this);
}
