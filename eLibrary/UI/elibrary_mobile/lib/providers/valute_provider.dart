import 'package:elibrary_mobile/models/valuta.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class ValutaProvider extends BaseProvider<Valuta> {
  ValutaProvider() : super("Valute");

  @override
  Valuta fromJson(data) {
    // TODO: implement fromJson
    return Valuta.fromJson(data);
  }
}
