import 'dart:async';
import 'dart:typed_data';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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
    final toDate = DateTime.now().toIso8601String();
    final Map<String, dynamic> details = {
      'deviceId': "",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'tagName': "",
      'timeFormat': timeFormat,
      'toDate': toDate,
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
    final toDate = DateTime.now().toIso8601String();
    final Map<String, dynamic> details = {
      'deviceId': "",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'tagName': "Di",
      'timeFormat': timeFormat,
      'toDate': toDate,
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
    final toDate = DateTime.now().toIso8601String();
    final Map<String, dynamic> details = {
      'deviceId': "175_NTH/QT_04",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'toDate': toDate,
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
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'deviceId': "175_NTH/QT_04",
      'fromDate': "2024-06-30T17:00:00.000Z",
      'tagName': "MUCNUOC",
      'timeFormat': timeFormat,
      'toDate': toDate,
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

  Future<Map<String, dynamic>> getWaterLevelByHours(String s) async {
    return await getWaterLevel('yy/MM/dd HH');
  }

  Future<Map<String, dynamic>> getWaterLevelByDay(String s) async {
    return await getWaterLevel('yy/MM/dd');
  }

  Future<Map<String, dynamic>> getWaterLevelByMonth(String s) async {
    return await getWaterLevel('yy/MM');
  }

  Future<Map<String, dynamic>> getWaterLevelByYear(String s) async {
    return await getWaterLevel('yyyy');
  }

  // Camera
  Stream<Uint8List> getCamera(String url) async* {
    final channel = WebSocketChannel.connect(Uri.parse(url));
    try {
      await for (var data in channel.stream) {
        yield data;
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    } finally {
      channel.sink.close(status.goingAway);
    }
  }

  Stream<Uint8List> getCamera1() =>
      getCamera("ws://api.ageo.vn:2000/api/stream/9091/103/0");
  Stream<Uint8List> getCamera2() =>
      getCamera("ws://api.ageo.vn:2000/api/stream/9092/103/0");
  Stream<Uint8List> getCamera3() =>
      getCamera("ws://api.ageo.vn:2000/api/stream/9093/103/0");
  Stream<Uint8List> getCamera4() =>
      getCamera("ws://api.ageo.vn:2000/api/stream/9094/103/0");
  Stream<Uint8List> getCamera5() =>
      getCamera("ws://api.ageo.vn:2000/api/stream/9095/103/0");

// GNSS
  Future<Map<String, dynamic>> getGnss(timeFormat) async {
    final apiToken = await _ss.readSecureData('access_token');
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'iaDeviceId': "M1",
      'fromDate': "2024-07-31T17:00:00.000Z",
      'tagName': "",
      'timeFormat': timeFormat,
      'toDate': toDate,
    };
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/IA/DataLogger/GetGNSSByHourDataLogger",
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

  Future<Map<String, dynamic>> getGnssbyRealTime(String s) async {
    return await getGnss('HH:mm:ss');
  }

  Future<Map<String, dynamic>> getGnssByHours(String s) async {
    return await getGnss('yy/MM/dd HH');
  }

  Future<Map<String, dynamic>> getGnssByDay(String s) async {
    return await getGnss('yy/MM/dd');
  }

  Future<Map<String, dynamic>> getGnssByMonth(String s) async {
    return await getGnss('yy/MM');
  }

  Future<Map<String, dynamic>> getGnssByYear(String s) async {
    return await getGnss('yyyy');
  }

   Future<Map<String, dynamic>> getGnssByRealtime(timeFormat) async {
    final apiToken = await _ss.readSecureData('access_token');
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'iaDeviceId': "M1",
      'fromDate': "2024-07-31T17:00:00.000Z",
      'tagName': "",
      'timeFormat': timeFormat,
      'toDate': toDate,
    };
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/IA/DataLogger/GetGNSSByHourDataLogger",
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
}
