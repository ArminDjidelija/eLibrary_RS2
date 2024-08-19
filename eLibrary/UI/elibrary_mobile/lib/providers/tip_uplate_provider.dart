import 'package:elibrary_mobile/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_mobile/models/tip_uplate.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class TipUplateProvider extends BaseProvider<TipUplate> {
  TipUplateProvider() : super("TipoviUplatum");

  @override
  TipUplate fromJson(data) {
    // TODO: implement fromJson
    return TipUplate.fromJson(data);
  }
}
