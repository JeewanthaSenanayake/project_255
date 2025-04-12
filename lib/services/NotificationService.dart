import 'dart:convert';
import '../globals.dart';
import 'package:http/http.dart' as http;

class NotificationService{
  Future <dynamic> fetchDataNotification() async{
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/message/all"),
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
}