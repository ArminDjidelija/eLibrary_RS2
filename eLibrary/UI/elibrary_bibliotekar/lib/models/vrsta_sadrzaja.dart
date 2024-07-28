import 'package:json_annotation/json_annotation.dart';
part 'vrsta_sadrzaja.g.dart';

@JsonSerializable()
class VrstaSadrzaja {
  int? vrstaSadrzajaId;
  String? naziv;

  VrstaSadrzaja();

  factory VrstaSadrzaja.fromJson(Map<String, dynamic> json) =>
      _$VrstaSadrzajaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VrstaSadrzajaToJson(this);
}
