import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/models/knjiga_autor.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';

class KnjigaAutoriProvider extends BaseProvider<KnjigaAutor> {
  KnjigaAutoriProvider() : super("KnjigaAutori");

  @override
  KnjigaAutor fromJson(data) {
    // TODO: implement fromJson
    return KnjigaAutor.fromJson(data);
  }
}
