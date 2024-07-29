import 'dart:convert';
import 'package:elibrary_mobile/models/izdavac.dart';
import 'package:elibrary_mobile/models/jezik.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/models/uvez.dart';
import 'package:elibrary_mobile/models/vrsta_grade.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class VrstaGradeProvider extends BaseProvider<VrstaGrade> {
  VrstaGradeProvider() : super("VrsteGrade");

  @override
  VrstaGrade fromJson(data) {
    // TODO: implement fromJson
    return VrstaGrade.fromJson(data);
  }
}
