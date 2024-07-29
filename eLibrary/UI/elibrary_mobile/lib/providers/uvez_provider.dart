import 'package:elibrary_mobile/models/uvez.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class UvezProvider extends BaseProvider<Uvez> {
  UvezProvider() : super("Uvezi");

  @override
  Uvez fromJson(data) {
    // TODO: implement fromJson
    return Uvez.fromJson(data);
  }
}
