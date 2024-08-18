import 'package:elibrary_bibliotekar/models/produzenje_pozajmice.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class ProduzenjePozajmiceProvider extends BaseProvider<ProduzenjePozajmice> {
  ProduzenjePozajmiceProvider() : super("ProduzenjePozajmica");

  @override
  ProduzenjePozajmice fromJson(data) {
    // TODO: implement fromJson
    return ProduzenjePozajmice.fromJson(data);
  }
}
