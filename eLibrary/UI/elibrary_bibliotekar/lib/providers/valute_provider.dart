import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class ValutaProvider extends BaseProvider<Valuta> {
  ValutaProvider() : super("Valute");

  @override
  Valuta fromJson(data) {
    // TODO: implement fromJson
    return Valuta.fromJson(data);
  }
}
