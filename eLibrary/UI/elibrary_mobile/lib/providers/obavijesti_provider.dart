import 'package:elibrary_mobile/models/obavijest.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class ObavijestiProvider extends BaseProvider<Obavijest> {
  ObavijestiProvider() : super("Obavijesti");

  @override
  Obavijest fromJson(data) {
    // TODO: implement fromJson
    return Obavijest.fromJson(data);
  }
}
