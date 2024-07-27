import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/knjiga_autor.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:flutter/material.dart';

class KnjigaAutoriProvider extends BaseProvider<KnjigaAutor> {
  KnjigaAutoriProvider() : super("KnjigaAutori");

  @override
  KnjigaAutor fromJson(data) {
    // TODO: implement fromJson
    return KnjigaAutor.fromJson(data);
  }
}
