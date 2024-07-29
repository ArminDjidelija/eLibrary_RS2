import 'package:elibrary_mobile/models/clanarina.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class ClanarineProvider extends BaseProvider<Clanarina> {
  ClanarineProvider() : super("Clanarine");

  @override
  Clanarina fromJson(data) {
    // TODO: implement fromJson
    return Clanarina.fromJson(data);
  }
}
