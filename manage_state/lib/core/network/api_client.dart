import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'token_manager.dart';

/// ===============================================================
/// API Exception
/// ===============================================================
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException('
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}

/// ===============================================================
/// Network Exception
/// ===============================================================
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

/// ===============================================================
/// API Client
/// Built with cross-platform package:http Client
/// ===============================================================
class ApiClient {
  final String baseUrl;
  final Duration timeout;

  final http.Client _httpClient;

  /// Manages access/refresh tokens.
  final TokenManager? tokenManager;

  /// Called when access token expires.
  ///
  /// Should:
  /// 1. Call refresh-token API
  /// 2. Save the new access token
  /// 3. Return true if successful
  /// 4. Return false if refresh failed
  final Future<bool> Function()? onRefreshToken;

  /// Prevents multiple refresh-token requests
  /// from running at the same time.
  Completer<bool>? _refreshCompleter;

  ApiClient({
    this.baseUrl = '',
    this.timeout = const Duration(seconds: 15),
    this.tokenManager,
    this.onRefreshToken,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  // ===============================================================
  // GET
  // ===============================================================

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) {
    return _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
      queryParams: queryParams,
    );
  }

  // ===============================================================
  // POST
  // ===============================================================

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    return _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===============================================================
  // PUT
  // ===============================================================

  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    return _sendRequest(
      method: 'PUT',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===============================================================
  // PATCH
  // ===============================================================

  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    return _sendRequest(
      method: 'PATCH',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===============================================================
  // DELETE
  // ===============================================================

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    return _sendRequest(
      method: 'DELETE',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===============================================================
  // UPLOAD FILE (MULTIPART)
  // ===============================================================

  Future<dynamic> uploadFile(
    String endpoint,
    dynamic file,
    String fieldName, {
    Map<String, String>? headers,
    String? filename,
  }) async {
    try {
      if (_refreshCompleter != null) {
        final success = await _refreshCompleter!.future;
        if (!success) {
          throw ApiException(statusCode: 401, message: 'Session expired');
        }
      }

      final uri = _buildUri(endpoint, null);
      final request = http.MultipartRequest('POST', uri);

      if (tokenManager != null && tokenManager!.hasToken) {
        request.headers['Authorization'] =
            'Bearer ${tokenManager!.accessToken}';
      }

      headers?.forEach((key, value) {
        request.headers[key] = value;
      });

      if (file is List<int>) {
        request.files.add(http.MultipartFile.fromBytes(
          fieldName,
          file,
          filename: filename ?? 'upload.bin',
        ));
      } else if (file is String) {
        request.files.add(await http.MultipartFile.fromPath(
          fieldName,
          file,
          filename: filename,
        ));
      } else if (file is http.MultipartFile) {
        request.files.add(file);
      } else {
        try {
          final path = (file as dynamic).path as String;
          request.files.add(await http.MultipartFile.fromPath(
            fieldName,
            path,
            filename: filename,
          ));
        } catch (_) {
          final bytes = await (file as dynamic).readAsBytes() as List<int>;
          request.files.add(http.MultipartFile.fromBytes(
            fieldName,
            bytes,
            filename: filename ?? 'file',
          ));
        }
      }

      final streamedResponse =
          await _httpClient.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);

      return _processResponse(response.statusCode, responseBody);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException('Upload error: $e');
    }
  }

  // ===============================================================
  // CORE REQUEST
  // ===============================================================

  Future<dynamic> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
    bool isRetry = false,
  }) async {
    try {
      // -------------------------------------------------------------
      // If another request is refreshing the token,
      // wait for it before sending this request.
      // -------------------------------------------------------------
      if (_refreshCompleter != null && !isRetry) {
        final success = await _refreshCompleter!.future;

        if (!success) {
          throw ApiException(
            statusCode: 401,
            message: 'Session expired',
          );
        }
      }

      // -------------------------------------------------------------
      // Build URL
      // -------------------------------------------------------------
      final uri = _buildUri(
        endpoint,
        queryParams,
      );

      // -------------------------------------------------------------
      // Create HTTP request
      // -------------------------------------------------------------
      final request = http.Request(method, uri);

      // Default headers
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.headers['Accept'] = 'application/json';

      // Authorization
      if (tokenManager != null && tokenManager!.hasToken) {
        request.headers['Authorization'] =
            'Bearer ${tokenManager!.accessToken}';
      }

      // Custom headers
      headers?.forEach((key, value) {
        request.headers[key] = value;
      });

      // Request body
      if (body != null) {
        final jsonString = body is String ? body : jsonEncode(body);
        request.body = jsonString;
      }

      // -------------------------------------------------------------
      // Send request
      // -------------------------------------------------------------
      final streamedResponse =
          await _httpClient.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);

      // -------------------------------------------------------------
      // Handle 401
      // -------------------------------------------------------------
      if (response.statusCode == 401 &&
          !isRetry &&
          onRefreshToken != null) {
        final refreshSuccess = await _refreshToken();

        // Refresh failed
        if (!refreshSuccess) {
          throw ApiException(
            statusCode: 401,
            message: 'Session expired',
          );
        }

        // Refresh succeeded
        // Retry original request once.
        return _sendRequest(
          method: method,
          endpoint: endpoint,
          headers: headers,
          queryParams: queryParams,
          body: body,
          isRetry: true,
        );
      }

      // -------------------------------------------------------------
      // Process response
      // -------------------------------------------------------------
      return _processResponse(
        response.statusCode,
        responseBody,
      );
    }

    // =============================================================
    // NETWORK ERRORS
    // =============================================================

    on TimeoutException {
      throw NetworkException(
        'Request timed out. Please try again.',
      );
    }

    on http.ClientException catch (e) {
      throw NetworkException(
        'No Internet connection or server unreachable: ${e.message}',
      );
    }

    // =============================================================
    // API ERRORS
    // =============================================================

    on ApiException {
      rethrow;
    }

    // =============================================================
    // UNEXPECTED ERRORS
    // =============================================================

    catch (e) {
      throw NetworkException(
        'Unexpected error: $e',
      );
    }
  }

  // ===============================================================
  // REFRESH TOKEN
  // ===============================================================

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final success = await onRefreshToken!();
      _refreshCompleter!.complete(success);
      return success;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  // ===============================================================
  // BUILD URI
  // ===============================================================

  Uri _buildUri(
    String endpoint,
    Map<String, dynamic>? queryParams,
  ) {
    final String fullUrl;

    if (baseUrl.isEmpty) {
      fullUrl = endpoint;
    } else {
      final normalizedBaseUrl = baseUrl.replaceFirst(
        RegExp(r'/$'),
        '',
      );

      final normalizedEndpoint = endpoint.replaceFirst(
        RegExp(r'^/'),
        '',
      );

      fullUrl = '$normalizedBaseUrl/$normalizedEndpoint';
    }

    final uri = Uri.parse(fullUrl);

    if (queryParams == null || queryParams.isEmpty) {
      return uri;
    }

    final params = queryParams.map(
      (key, value) {
        if (value is Iterable) {
          return MapEntry(
            key,
            value.map((e) => e.toString()).toList(),
          );
        }
        return MapEntry(
          key,
          value.toString(),
        );
      },
    );

    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...params,
      },
    );
  }

  // ===============================================================
  // PROCESS RESPONSE
  // ===============================================================

  dynamic _processResponse(
    int statusCode,
    String responseBody,
  ) {
    dynamic decodedData;

    if (responseBody.isNotEmpty) {
      try {
        decodedData = jsonDecode(responseBody);
      } catch (_) {
        decodedData = responseBody;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedData;
    }

    String message = 'HTTP Error $statusCode';

    if (decodedData is Map) {
      if (decodedData['message'] != null) {
        message = decodedData['message'].toString();
      } else if (decodedData['error'] != null) {
        message = decodedData['error'].toString();
      }
    }

    throw ApiException(
      statusCode: statusCode,
      message: message,
      data: decodedData,
    );
  }

  // ===============================================================
  // DISPOSE
  // ===============================================================

  void dispose() {
    _httpClient.close();
  }
}