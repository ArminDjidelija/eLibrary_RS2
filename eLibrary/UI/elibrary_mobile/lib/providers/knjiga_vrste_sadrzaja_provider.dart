import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/models/knjiga_autor.dart';
import 'package:elibrary_mobile/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_mobile/models/knjiga_vrsta_sadrzaja.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';

class KnjigaVrsteSadrzajaProvider extends BaseProvider<KnjigaVrstaSadrzaja> {
  KnjigaVrsteSadrzajaProvider() : super("KnjigaVrsteSadrzaja");

  @override
  KnjigaVrstaSadrzaja fromJson(data) {
    // TODO: implement fromJson
    return KnjigaVrstaSadrzaja.fromJson(data);
  }
}
