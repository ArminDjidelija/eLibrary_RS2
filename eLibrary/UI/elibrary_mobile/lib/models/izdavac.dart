import 'package:json_annotation/json_annotation.dart';
part 'izdavac.g.dart';

@JsonSerializable()
class Izdavac {
  int? izdavacId;
  String? naziv;
  Izdavac();

  factory Izdavac.fromJson(Map<String, dynamic> json) =>
      _$IzdavacFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$IzdavacToJson(this);
}
