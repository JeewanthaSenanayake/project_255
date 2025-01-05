import 'dart:convert';

import '../globals.dart';
import 'package:http/http.dart' as http;

class MapAndStats {
  Future<dynamic> getMemberOnDistrict(String district) async {
    try {
      final response = await http.get(
        Uri.parse(
            "$baseUrl/api/v1/map/get_lobbyist_by_district?district=$district"),
      );
      if (response.statusCode == 200) {
        if (json.decode(response.body).length != 0) {
          var decodedResponse = utf8.decode(response.bodyBytes);
          return jsonDecode(decodedResponse);
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

  Future<dynamic> getMemberById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/lobbyist/get_lobbyist_by_id/$id"),
      );
      if (response.statusCode == 200) {
        if (json.decode(response.body).length != 0) {
          var decodedResponse = utf8.decode(response.bodyBytes);
          return jsonDecode(decodedResponse)[0];
          // return json.decode(response.body)[0];
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

  Future<dynamic> addComment(String id, dynamic coment, String memberDistrict) async {
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/api/v1/lobbyist/add_comment_for_lobbyist/$id/$memberDistrict"),
          headers: {'Content-Type': 'application/json'},
          body: json.encoder.convert(coment));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      //print(e);
      return false;
    }
  }
}
