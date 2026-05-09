import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {

  final dio = Dio(

    BaseOptions(

      baseUrl: 'http://127.0.0.1:8000/project225',

      connectTimeout: const Duration(seconds: 30),

      receiveTimeout: const Duration(seconds: 30),

      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(

    InterceptorsWrapper(

      onRequest: (options, handler) async {

        const storage = FlutterSecureStorage();

        String? token =
            await storage.read(key: 'token');

        if (token != null) {

          options.headers['Authorization'] =
              'Bearer $token';
        }

        return handler.next(options);
      },

      onResponse: (response, handler) {

        print("SUCCESS: ${response.statusCode}");

        return handler.next(response);
      },

      onError: (DioException error, handler) {

        print("ERROR: ${error.message}");

        return handler.next(error);
      },
    ),
  );

  return dio;
});