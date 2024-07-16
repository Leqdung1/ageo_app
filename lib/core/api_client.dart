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

  // Piezometer
  Future<Map<String, dynamic>> getPiezometerData(timeFormat) async {
    final apiToken = await _ss.readSecureData("access_token");
    final Map<String, dynamic> details = {
      'deviceId': "",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'tagName': "",
      'timeFormat': timeFormat,
      'toDate': "2024-07-15T15:26:43.851Z",
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

  Future<Map<String, dynamic>> getPiezometerbyHours(String s) async {
    return await getPiezometerData("yy/MM/dd HH");
  }

  Future<Map<String, dynamic>> getPiezometerbyDay(String s) async {
    return await getPiezometerData("yy/MM/dd");
  }

  Future<Map<String, dynamic>> getPiezometerbyMonth(String s) async {
    return await getPiezometerData("yy/MM");
  }

  Future<Map<String, dynamic>> getPiezometerbyYear(String s) async {
    return await getPiezometerData("yyyy");
  }

  // Inclinometer
  Future<Map<String, dynamic>> getInclinometerData(timeFormat) async {
    final apiToken = await _ss.readSecureData("access_token");
    final Map<String, dynamic> details = {
      'deviceId': "",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'tagName': "Di",
      'timeFormat': timeFormat,
      'toDate': "2024-07-15T16:52:33.145Z",
    };
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/IA/DataLogger/GetInclinometerByTagDataLogger",
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

  Future<Map<String, dynamic>> getInclinometerbyHours(String s) async {
    return await getInclinometerData("yy/MM/dd HH");
  }

  Future<Map<String, dynamic>> getInclinometerbyDay(String s) async {
    return await getInclinometerData("yy/MM/dd");
  }

  Future<Map<String, dynamic>> getInclinometerbyMonth(String s) async {
    return await getInclinometerData("yy/MM");
  }

  Future<Map<String, dynamic>> getInclinometerbyYear(String s) async {
    return await getInclinometerData("yyyy");
  }

  // Rain gauge
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

  Future<Map<String, dynamic>> getRainDataByMonth(String s) async {
    return await getRainData('yy/MM');
  }

  Future<Map<String, dynamic>> getRainDataByYear(String s) async {
    return await getRainData('yyyy');
  }

  // Water Leverl
  Future<Map<String, dynamic>> getWaterLevel(timeFormat) async {
    final apiToken = await _ss.readSecureData('access_token');
    final details = {
      'deviceId': "175_NTH/QT_04",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'tagName': "MUCNUOC",
      'timeFormat': timeFormat,
      'toDate': "2024-07-15T16:13:57.088Z",
    };
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/IA/DataLogger/GetWaterLevelDataLogger",
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

  Future<Map<String, dynamic>> getWaterLevelByHours(String s) async{
    return await getWaterLevel('yy/MM/dd HH');
  }

   Future<Map<String, dynamic>> getWaterLevelByDay(String s) async{
    return await getWaterLevel('yy/MM/dd');
  }

   Future<Map<String, dynamic>> getWaterLevelByMonth(String s) async{
    return await getWaterLevel('yy/MM');
  }

   Future<Map<String, dynamic>> getWaterLevelByYear(String s) async{
    return await getWaterLevel('yyyy');
  }
  }

