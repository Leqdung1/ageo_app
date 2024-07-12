import 'package:Ageo_solutions/core/helpers.dart';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
  final RetryOptions _r = const RetryOptions(maxAttempts: 4);
  final SecureStorage _ss = SecureStorage();
  static const String _apiUrl = "http://api.ageo.vn";

  Future<Map<String, dynamic>> login(String username, String password) async {
    Map<String, String> details = {
      "grant_type": "password",
      "scope": "openid profile email",
      "client_id": "nabit-client",
      "username": username,
      "password": password,
    };

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/core/connect/token",
          data: details,
          options: Options(contentType: Headers.formUrlEncodedContentType),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }
          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final apiToken = await _ss.readSecureData("access_token");
    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/core/Users/GetMyInfo",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  // Future<Map<String, dynamic>> fetchMap() async {

  //   const url =
  //       'https://maps.googleapis.com/$rpc/google.internal.maps.mapsjs.v1.MapsJsInternalService/GetViewportInfo';
  //   final headers = {
  //     'Content-Type': 'application/json+protobuf',
  //     'X-User-Agent': 'grpc-web-javascript/0.1',
  //     'X-Goog-Api-Key': 'AIzaSyCh9jrIWNsgJ-SsMJp1XizFpGTM0sL1gPI',
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       throw Exception(
  //           'Failed to load viewport info. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to fetch map data: $e');
  //   }
  // }
}
