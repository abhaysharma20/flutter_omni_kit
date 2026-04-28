import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'logger.dart';

/// A simplified API client wrapper using Dio with built-in connectivity checks and logging.
class OmniNetwork {
  static final OmniNetwork _instance = OmniNetwork._internal();
  factory OmniNetwork() => _instance;
  OmniNetwork._internal();

  final Dio _dio = Dio();

  /// Initialize with base options
  void init({
    required String baseUrl,
    Map<String, dynamic>? headers,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = headers;
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.receiveTimeout = receiveTimeout;
  }

  Future<bool> get isConnected async {
    final dynamic result = await Connectivity().checkConnectivity();
    if (result is List) {
      return !result.contains(ConnectivityResult.none) && result.isNotEmpty;
    }
    return result != ConnectivityResult.none;
  }

  /// Perform a GET request
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!await isConnected) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: "No internet connection",
        type: DioExceptionType.connectionError,
      );
    }

    try {
      Logger.i("GET Request: \${_dio.options.baseUrl}\$path");
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      Logger.e("GET Error: \$e");
      rethrow;
    }
  }

  /// Perform a POST request
  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (!await isConnected) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: "No internet connection",
        type: DioExceptionType.connectionError,
      );
    }

    try {
      Logger.i("POST Request: \${_dio.options.baseUrl}\$path");
      return await _dio.post(path,
          data: data, queryParameters: queryParameters);
    } catch (e) {
      Logger.e("POST Error: \$e");
      rethrow;
    }
  }
}
