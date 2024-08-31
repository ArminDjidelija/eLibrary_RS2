import 'dart:convert';

import 'package:elibrary_mobile/models/uplata.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UplataProvider extends BaseProvider<Uplata> {
  UplataProvider() : super("Uplate");

  @override
  Uplata fromJson(data) {
    // TODO: implement fromJson
    return Uplata.fromJson(data);
  }

  Future<Map<String, dynamic>> makePaymentIntent(
      double amount, String currency) async {
    final body = {
      'amount': '200',
      'currency': 'USD',
      'payment_method_types[]': 'card',
    };
    var key = dotenv.env['_stripeKey'];

    final headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: headers,
      body: body,
    );
    var bodyy = jsonDecode(response.body);
    print(bodyy);
    return jsonDecode(response.body);
  }
}
