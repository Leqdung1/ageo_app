import 'dart:async';

import 'package:Ageo_solutions/core/helpers.dart';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';

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

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final apiToken = await _ss.readSecureData("access_token");
    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/Staff/GetByUserId?userId=$userId",
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

  Future<Map<String, dynamic>> getPiezometerData(
      String logTime,
      double pz1,
      double pz2,
      double pz3,
      double pz4,
      double pz5,
      double pz6,
      double pz7,
      double pz8) async {
    final apiToken = await _ss.readSecureData("access_token");

    final Map<String, dynamic> details = {
      "success": true,
      "data": [
        {
          "logTime": logTime,
          "pz1": pz1,
          "pz2": pz2,
          "pz3": pz3,
          "pz4": pz4,
          "pz5": pz5,
          "pz6": pz6,
          "pz7": pz7,
          "pz8": pz8,
        }
      ],
      "error": null,
      "message": "",
      "status": null,
      "totalRecord": 0,
      "correlationId": null,
    };

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/IA/DataLogger/GetPiezometerDataLogger",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
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

  Future<Map<String, dynamic>> getRainData(timeFormat) async {
    final apiToken = await _ss.readSecureData("access_token");

    

    final Map<String, dynamic> details = {
      'deviceId': "175_NTH/QT_04",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'toDate': "2024-07-15T03:38:55.170Z",
      'tagName': "MUCNUOC",
      'timeFormat': timeFormat
    };

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/IA/DataLogger/GetRainMmTotDataLogger",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
              'Content-Type': 'application/json',
            },
          ),
          data: details,
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

    Future<Map<String, dynamic>> getRainDataByHours(String s) async {
    return await getRainData('yy/MM/dd HH');
  }

  Future<Map<String, dynamic>> getRainDataByDay(String s) async {
    return await getRainData('yy/MM/dd');
  }

  Future<Map<String, dynamic>> getRainDataByMonth(String s) async{
    return await getRainData('yy/MM');
  }

  Future<Map<String, dynamic>> getRainDataByYear(String s) async{
    return await getRainData('yyyy');
  } 


}
