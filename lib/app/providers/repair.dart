

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/repair.dart';
import 'auth.dart';

class RepairProvider extends ChangeNotifier {
  final Auth auth;
  String apiVersionV1Link;
  Map<String, String> _headers;

  get headers {
    print("getting headers");
    return {
      "Authorization": "Bearer ${auth.token}",
      "Content-Type": "application/json"
    };
  }

  RepairProvider({this.auth}) {
    print("I was run ");
    apiVersionV1Link = "${this.auth.baseApiUrl}/api/v1";
  }

  Future<http.Response> getVehicleTypes() async {
    final url = "$apiVersionV1Link/car-types/";
    return http.get(url, headers: headers);
  }


  Future<http.Response> postVehicle(Repair repair) {
    final url = "$apiVersionV1Link/repairs/";
    return http.post(url, body: repair.toHttpBody(), headers: headers);
  }


}