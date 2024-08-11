import 'package:elibrary_bibliotekar/models/uloga.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class UlogeProvider extends BaseProvider<Uloga> {
  UlogeProvider() : super("Uloge");

  @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }
}
