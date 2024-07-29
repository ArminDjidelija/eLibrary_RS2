import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/models/knjiga_autor.dart';
import 'package:elibrary_mobile/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';

class KnjigaCiljnaGrupaProvider extends BaseProvider<KnjigaCiljnaGrupa> {
  KnjigaCiljnaGrupaProvider() : super("KnjigaCiljneGrupe");

  @override
  KnjigaCiljnaGrupa fromJson(data) {
    // TODO: implement fromJson
    return KnjigaCiljnaGrupa.fromJson(data);
  }
}
