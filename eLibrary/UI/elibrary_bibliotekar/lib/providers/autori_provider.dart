import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class AutoriProvider extends BaseProvider<Autor> {
  AutoriProvider() : super("Autori");

  @override
  Autor fromJson(data) {
    // TODO: implement fromJson
    return Autor.fromJson(data);
  }
}
