import 'package:json_annotation/json_annotation.dart';
part 'pozajmica_info.g.dart';

@JsonSerializable()
class PozajmicaInfo {
  int? mjesecInt;
  int? rb;
  String? mjesecString;
  int? brojPozajmica;
  PozajmicaInfo();

  factory PozajmicaInfo.fromJson(Map<String, dynamic> json) =>
      _$PozajmicaInfoFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PozajmicaInfoToJson(this);
}
