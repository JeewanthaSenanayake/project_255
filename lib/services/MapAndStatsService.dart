import 'dart:convert';

import '../globals.dart';
import 'package:http/http.dart' as http;

class MapAndStats{
  Future<dynamic> getMemberOnDistrict(String district) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/map/get_lobbyist_by_district?district=$district"),
      );
      if (response.statusCode == 200) {
        if (json.decode(response.body).length != 0) {
          return json.decode(response.body);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      //print(e);
      return null;
    }
  }
}