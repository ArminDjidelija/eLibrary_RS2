import 'package:json_annotation/json_annotation.dart';
part 'uvez.g.dart';

@JsonSerializable()
class Uvez {
  int? uvezId;
  String? naziv;
  Uvez();
  factory Uvez.fromJson(Map<String, dynamic> json) => _$UvezFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UvezToJson(this);
}
