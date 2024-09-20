import 'dart:async';
import 'dart:typed_data';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

  // User Data
  Future<Map<String, dynamic>> getUserData(int userId) async {
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

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      return e.response?.data ?? {'error': 'Unknown error occurred'};
    } catch (e) {
      print("Error: $e");
      return {'error': 'Failed to fetch data'};
    }
  }

  Future<int?> getUserIdFromToken() async {
    final apiToken = await _ss.readSecureData("access_token");
    if (apiToken != null && JwtDecoder.isExpired(apiToken) == false) {
      final decodedToken = JwtDecoder.decode(apiToken);
      return decodedToken['userId'] as int?;
    }
    return null;
  }

  // User
  Future<Map<String, dynamic>> getUser(int userId) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/core/users/$userId",
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

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      return e.response?.data ?? {'error': 'Unknown error occurred'};
    } catch (e) {
      print("Error: $e");
      return {'error': 'Failed to fetch data'};
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassWord(
    Map<String, dynamic> userData, String oldPassword, String newPassword) async {
  final apiToken = await _ss.readSecureData("access_token");
  userData["oldPassword"] = oldPassword;
  userData["newPassword"] = newPassword;

  try {
    final response = await _r.retry(
      () async => await _dio.post(
        "$_apiUrl/core/users/ChangePassword",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
        data: userData,
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
    return e.response?.data ?? {'error': 'Unknown error occurred'};
  }
}


  // Piezometer
  Future<Map<String, dynamic>> getPiezometerData(
      timeFormat, DateTime fromDate) async {
    final apiToken = await _ss.readSecureData("access_token");
    final toDate = DateTime.now().toIso8601String();

    final Map<String, dynamic> details = {
      'deviceId': "",
      'fromDate': fromDate.toIso8601String(),
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

  Future<Map<String, dynamic>> getPiezometerbyHours(DateTime fromDate) async {
    return await getPiezometerData("yy/MM/dd HH", fromDate);
  }

  Future<Map<String, dynamic>> getPiezometerbyDay(DateTime fromDate) async {
    return await getPiezometerData("yy/MM/dd", fromDate);
  }

  Future<Map<String, dynamic>> getPiezometerbyMonth(DateTime fromDate) async {
    return await getPiezometerData("yy/MM", fromDate);
  }

  Future<Map<String, dynamic>> getPiezometerbyYear(DateTime fromDate) async {
    return await getPiezometerData("yyyy", fromDate);
  }

  // Inclinometer
  Future<Map<String, dynamic>> getInclinometerData(
      timeFormat, DateTime fromDate) async {
    final apiToken = await _ss.readSecureData("access_token");
    final toDate = DateTime.now().toIso8601String();
    final Map<String, dynamic> details = {
      'deviceId': "",
      'fromDate': fromDate.toIso8601String(),
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

  Future<Map<String, dynamic>> getInclinometerbyHours(DateTime fromDate) async {
    return await getInclinometerData("yy/MM/dd HH", fromDate);
  }

  Future<Map<String, dynamic>> getInclinometerbyDay(DateTime fromDate) async {
    return await getInclinometerData("yy/MM/dd", fromDate);
  }

  Future<Map<String, dynamic>> getInclinometerbyMonth(DateTime fromDate) async {
    return await getInclinometerData("yy/MM", fromDate);
  }

  Future<Map<String, dynamic>> getInclinometerbyYear(DateTime fromDate) async {
    return await getInclinometerData("yyyy", fromDate);
  }

  // Rain gauge
  Future<Map<String, dynamic>> getRainData(
      timeFormat, DateTime fromDate) async {
    final apiToken = await _ss.readSecureData("access_token");
    final toDate = DateTime.now().toIso8601String();
    final Map<String, dynamic> details = {
      'deviceId': "175_NTH/QT_04",
      'fromDate': fromDate.toIso8601String(),
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

  Future<Map<String, dynamic>> getRainDataByHours(DateTime fromDate) async {
    return await getRainData('yy/MM/dd HH', fromDate);
  }

  Future<Map<String, dynamic>> getRainDataByDay(DateTime fromDate) async {
    return await getRainData('yy/MM/dd', fromDate);
  }

  Future<Map<String, dynamic>> getRainDataByMonth(DateTime fromDate) async {
    return await getRainData('yy/MM', fromDate);
  }

  Future<Map<String, dynamic>> getRainDataByYear(DateTime fromDate) async {
    return await getRainData('yyyy', fromDate);
  }

  // Water Leverl
  Future<Map<String, dynamic>> getWaterLevel(
      timeFormat, DateTime fromDate) async {
    final apiToken = await _ss.readSecureData('access_token');
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'deviceId': "175_NTH/QT_04",
      'fromDate': fromDate.toIso8601String(),
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

  Future<Map<String, dynamic>> getWaterLevelByHours(DateTime fromDate) async {
    return await getWaterLevel('yy/MM/dd HH', fromDate);
  }

  Future<Map<String, dynamic>> getWaterLevelByDay(DateTime fromDate) async {
    return await getWaterLevel('yy/MM/dd', fromDate);
  }

  Future<Map<String, dynamic>> getWaterLevelByMonth(DateTime fromDate) async {
    return await getWaterLevel('yy/MM', fromDate);
  }

  Future<Map<String, dynamic>> getWaterLevelByYear(DateTime fromDate) async {
    return await getWaterLevel('yyyy', fromDate);
  }

  // GNSS
  Future<Map<String, dynamic>> getGnss(
      timeFormat, DateTime fromDate, deviceId) async {
    final apiToken = await _ss.readSecureData('access_token');
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'iaDeviceId': deviceId,
      'fromDate': fromDate.toIso8601String(),
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

  Future<Map<String, dynamic>> getGnssbyRealTime(
      DateTime fromDate, String deviceId) async {
    return await getGnss('HH:mm:ss', fromDate, deviceId);
  }

  Future<Map<String, dynamic>> getGnssByHours(
      DateTime fromDate, String deviceId) async {
    return await getGnss('yy/MM/dd HH', fromDate, deviceId);
  }

  Future<Map<String, dynamic>> getGnssByDay(
      DateTime fromDate, String deviceId) async {
    return await getGnss(
      'yy/MM/dd',
      fromDate,
      deviceId
    );
  }

  Future<Map<String, dynamic>> getGnssByMonth(
      DateTime fromDate, String deviceId) async {
    return await getGnss(
      'yy/MM',
      fromDate,
      deviceId
    );
  }

  Future<Map<String, dynamic>> getGnssByYear(
      DateTime fromDate, String deviceId) async {
    return await getGnss(
      'yyyy',
      fromDate,
      deviceId
    );
  }

  Future<Map<String, dynamic>> getGnssByRealtime(
      timeFormat, DateTime fromDate) async {
    final apiToken = await _ss.readSecureData('access_token');
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'iaDeviceId': "M1",
      'fromDate': fromDate.toIso8601String(),
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


  // Common data logger 
   Future<Map<String, dynamic>> getCommonData(
      timeFormat, DateTime fromDate) async {
    final apiToken = await _ss.readSecureData('access_token');
    final toDate = DateTime.now().toIso8601String();
    final details = {
      'deviceId': "",
      'fromDate': fromDate.toIso8601String(),
      'tagName': "",
      'timeFormat': timeFormat,
      'toDate': toDate,
    };
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl//IA/DataLogger/GetCommonDataLogger",
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

  Future<Map<String, dynamic>> getCommonDataByHours(DateTime fromDate) async {
    return await getCommonData('yy/MM/dd HH', fromDate);
  }

  Future<Map<String, dynamic>> getCommonDataByDay(DateTime fromDate) async {
    return await getCommonData('yy/MM/dd', fromDate);
  }

  Future<Map<String, dynamic>> getCommonDataByMonth(DateTime fromDate) async {
    return await getCommonData('yy/MM', fromDate);
  }

  Future<Map<String, dynamic>> getCommonDataByYear(DateTime fromDate) async {
    return await getCommonData('yyyy', fromDate);
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

  // warn
  Future<Map<String, dynamic>> getDeviceData() async {
    final apiToken = await _ss.readSecureData("access_token");
    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/IA/Device/GetByProject/DL01",
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
}
