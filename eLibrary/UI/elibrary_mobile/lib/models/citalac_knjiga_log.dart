import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:json_annotation/json_annotation.dart';
part 'citalac_knjiga_log.g.dart';

@JsonSerializable()
class CitalacKnjigaLog {
  int? citalacKnjigaLogId;
  int? citalacId;
  int? knjigaId;
  Citalac? citalac;
  Knjiga? knjiga;

  CitalacKnjigaLog();

  factory CitalacKnjigaLog.fromJson(Map<String, dynamic> json) =>
      _$CitalacKnjigaLogFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CitalacKnjigaLogToJson(this);
}
