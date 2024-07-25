import 'package:elibrary_bibliotekar/models/ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class CiljneGrupeProvider extends BaseProvider<CiljnaGrupa> {
  CiljneGrupeProvider() : super("CiljneGrupe");

  @override
  CiljnaGrupa fromJson(data) {
    // TODO: implement fromJson
    return CiljnaGrupa.fromJson(data);
  }
}
