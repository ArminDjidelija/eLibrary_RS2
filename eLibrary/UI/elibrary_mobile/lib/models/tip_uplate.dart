import 'package:json_annotation/json_annotation.dart';
part 'tip_uplate.g.dart';

@JsonSerializable()
class TipUplate {
  int? tipUplateId;
  String? naziv;
  TipUplate();
  factory TipUplate.fromJson(Map<String, dynamic> json) =>
      _$TipUplateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TipUplateToJson(this);
}
