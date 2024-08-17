import 'package:elibrary_bibliotekar/models/tip_uplate.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class TipUplateProvider extends BaseProvider<TipUplate> {
  TipUplateProvider() : super("TipoviUplatum");

  @override
  TipUplate fromJson(data) {
    // TODO: implement fromJson
    return TipUplate.fromJson(data);
  }
}
