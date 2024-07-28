import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/knjiga_autor.dart';
import 'package:elibrary_bibliotekar/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:flutter/material.dart';

class KnjigaCiljnaGrupaProvider extends BaseProvider<KnjigaCiljnaGrupa> {
  KnjigaCiljnaGrupaProvider() : super("KnjigaCiljneGrupe");

  @override
  KnjigaCiljnaGrupa fromJson(data) {
    // TODO: implement fromJson
    return KnjigaCiljnaGrupa.fromJson(data);
  }
}
