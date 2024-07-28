import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class PozajmiceProvider extends BaseProvider<Pozajmica> {
  PozajmiceProvider() : super("Pozajmice");

  @override
  Pozajmica fromJson(data) {
    // TODO: implement fromJson
    return Pozajmica.fromJson(data);
  }
}
