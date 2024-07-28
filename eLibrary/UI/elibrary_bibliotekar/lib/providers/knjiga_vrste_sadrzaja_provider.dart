import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/knjiga_autor.dart';
import 'package:elibrary_bibliotekar/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/models/knjiga_vrsta_sadrzaja.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:flutter/material.dart';

class KnjigaVrsteSadrzajaProvider extends BaseProvider<KnjigaVrstaSadrzaja> {
  KnjigaVrsteSadrzajaProvider() : super("KnjigaVrsteSadrzaja");

  @override
  KnjigaVrstaSadrzaja fromJson(data) {
    // TODO: implement fromJson
    return KnjigaVrstaSadrzaja.fromJson(data);
  }
}
