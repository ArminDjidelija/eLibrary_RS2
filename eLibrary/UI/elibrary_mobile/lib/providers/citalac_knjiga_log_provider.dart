import 'package:elibrary_mobile/models/ciljna_grupa.dart';
import 'package:elibrary_mobile/models/citalac_knjiga_log.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class CitalacKnjigaLogProvider extends BaseProvider<CitalacKnjigaLog> {
  CitalacKnjigaLogProvider() : super("CitalacKnjigaLogs");

  @override
  CitalacKnjigaLog fromJson(data) {
    // TODO: implement fromJson
    return CitalacKnjigaLog.fromJson(data);
  }
}
