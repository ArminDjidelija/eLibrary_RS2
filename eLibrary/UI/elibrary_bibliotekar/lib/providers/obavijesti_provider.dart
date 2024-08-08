import 'package:elibrary_bibliotekar/models/obavijest.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class ObavijestiProvider extends BaseProvider<Obavijest> {
  ObavijestiProvider() : super("Obavijesti");

  @override
  Obavijest fromJson(data) {
    // TODO: implement fromJson
    return Obavijest.fromJson(data);
  }
}
