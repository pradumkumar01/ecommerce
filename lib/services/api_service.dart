import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/services/logger_service.dart';
import 'package:ecommerce/services/network_service.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.apiTimeout),
        receiveTimeout: const Duration(seconds: AppConstants.apiTimeout),
        contentType: 'application/json',
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          LoggerService.info('${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          LoggerService.info('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          LoggerService.error('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    int retries = 0,
  }) async {
    try {
      final hasInternet = await NetworkService.hasInternet();
      if (!hasInternet) {
        throw Exception(ErrorMessages.noInternetError);
      }

      final response = await _dio.get(path, queryParameters: queryParameters);

      return response.data;
    } on DioException {
      if (retries < AppConstants.maxRetries) {
        await Future.delayed(AppConstants.retryDelay);
        return get(
          path,
          queryParameters: queryParameters,
          retries: retries + 1,
        );
      }
      rethrow;
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int retries = 0,
  }) async {
    try {
      final hasInternet = await NetworkService.hasInternet();
      if (!hasInternet) {
        throw Exception(ErrorMessages.noInternetError);
      }

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException {
      if (retries < AppConstants.maxRetries) {
        await Future.delayed(AppConstants.retryDelay);
        return post(
          path,
          data: data,
          queryParameters: queryParameters,
          retries: retries + 1,
        );
      }
      rethrow;
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int retries = 0,
  }) async {
    try {
      final hasInternet = await NetworkService.hasInternet();
      if (!hasInternet) {
        throw Exception(ErrorMessages.noInternetError);
      }

      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException {
      if (retries < AppConstants.maxRetries) {
        await Future.delayed(AppConstants.retryDelay);
        return put(
          path,
          data: data,
          queryParameters: queryParameters,
          retries: retries + 1,
        );
      }
      rethrow;
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int retries = 0,
  }) async {
    try {
      final hasInternet = await NetworkService.hasInternet();
      if (!hasInternet) {
        throw Exception(ErrorMessages.noInternetError);
      }

      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException {
      if (retries < AppConstants.maxRetries) {
        await Future.delayed(AppConstants.retryDelay);
        return delete(
          path,
          data: data,
          queryParameters: queryParameters,
          retries: retries + 1,
        );
      }
      rethrow;
    }
  }
}
