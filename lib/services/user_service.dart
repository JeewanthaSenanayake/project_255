import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await dio
        .post('/user/login', data: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      storage.write(key: 'token', value: response.data['access_token']);

      return true;
    } else {
      return false;
    }
  }

  Future createUser(
    Map<String, dynamic> data,
  ) async {
    final response = await dio.post(
      '/users',
      data: data,
    );

    return response.data;
  }
}
