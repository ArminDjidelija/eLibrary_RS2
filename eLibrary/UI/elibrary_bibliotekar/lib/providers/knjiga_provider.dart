import 'dart:convert';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class KnjigaProvider extends BaseProvider<Knjiga> {
  KnjigaProvider() : super("Knjige");

  @override
  Knjiga fromJson(data) {
    // TODO: implement fromJson
    return Knjiga.fromJson(data);
  }
}
