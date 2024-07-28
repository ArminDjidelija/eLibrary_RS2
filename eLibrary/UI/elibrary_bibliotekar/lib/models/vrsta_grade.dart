import 'package:json_annotation/json_annotation.dart';

part 'vrsta_grade.g.dart';

@JsonSerializable()
class VrstaGrade {
  int? vrstaGradeId;
  String? naziv;
  VrstaGrade();
  factory VrstaGrade.fromJson(Map<String, dynamic> json) =>
      _$VrstaGradeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VrstaGradeToJson(this);
}
