import 'package:elibrary_bibliotekar/models/kanton.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class KantonProvider extends BaseProvider<Kanton> {
  KantonProvider() : super("Kantoni");

  @override
  Kanton fromJson(data) {
    // TODO: implement fromJson
    return Kanton.fromJson(data);
  }
}
