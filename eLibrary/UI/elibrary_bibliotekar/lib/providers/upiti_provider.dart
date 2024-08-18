import 'package:elibrary_bibliotekar/models/upit.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class UpitiProvider extends BaseProvider<Upit> {
  UpitiProvider() : super("Upiti");

  @override
  Upit fromJson(data) {
    // TODO: implement fromJson
    return Upit.fromJson(data);
  }
}
