import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
/// Built with dart:io HttpClient
/// ===============================================================
class ApiClient {
  final String baseUrl;
  final Duration timeout;

  final HttpClient _httpClient;

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
  }) : _httpClient = HttpClient() {
    _httpClient.connectionTimeout = timeout;
  }

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
      // Open request
      // -------------------------------------------------------------
      final request = await _httpClient
          .openUrl(method, uri)
          .timeout(timeout);

      // -------------------------------------------------------------
      // Default headers
      // -------------------------------------------------------------
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json; charset=utf-8',
      );

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      // -------------------------------------------------------------
      // Authorization
      // -------------------------------------------------------------
      if (tokenManager != null &&
          tokenManager!.hasToken) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer ${tokenManager!.accessToken}',
        );
      }

      // -------------------------------------------------------------
      // Custom headers
      // -------------------------------------------------------------
      headers?.forEach((key, value) {
        request.headers.set(key, value);
      });

      // -------------------------------------------------------------
      // Request body
      // -------------------------------------------------------------
      if (body != null) {
        final jsonString = body is String
            ? body
            : jsonEncode(body);

        final bytes = utf8.encode(jsonString);
        request.headers.contentLength = bytes.length;
        request.add(bytes);
      }

      // -------------------------------------------------------------
      // Send request
      // -------------------------------------------------------------
      final response = await request
          .close()
          .timeout(timeout);

      // -------------------------------------------------------------
      // Read response
      // -------------------------------------------------------------
      final responseBody = await response
          .transform(utf8.decoder)
          .join();

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

    on SocketException catch (e) {
      throw NetworkException(
        'No Internet connection or server unreachable: '
        '${e.message}',
      );
    }

    on TimeoutException {
      throw NetworkException(
        'Request timed out. Please try again.',
      );
    }

    on HttpException catch (e) {
      throw NetworkException(
        'HTTP error: ${e.message}',
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
    // -------------------------------------------------------------
    // Another request is already refreshing.
    // Wait for that same refresh operation.
    // -------------------------------------------------------------
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    // -------------------------------------------------------------
    // Create refresh completer
    // -------------------------------------------------------------
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
      final normalizedBaseUrl =
          baseUrl.replaceFirst(
        RegExp(r'/$'),
        '',
      );

      final normalizedEndpoint =
          endpoint.replaceFirst(
        RegExp(r'^/'),
        '',
      );

      fullUrl =
          '$normalizedBaseUrl/$normalizedEndpoint';
    }

    final uri = Uri.parse(fullUrl);

    // No query parameters
    if (queryParams == null ||
        queryParams.isEmpty) {
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

    // -------------------------------------------------------------
    // Decode JSON
    // -------------------------------------------------------------
    if (responseBody.isNotEmpty) {
      try {
        decodedData = jsonDecode(responseBody);
      } catch (_) {
        // Server returned plain text
        decodedData = responseBody;
      }
    }

    // -------------------------------------------------------------
    // Success: 200 - 299
    // -------------------------------------------------------------
    if (statusCode >= 200 &&
        statusCode < 300) {
      return decodedData;
    }

    // -------------------------------------------------------------
    // Error
    // -------------------------------------------------------------
    String message = 'HTTP Error $statusCode';

    if (decodedData is Map) {
      if (decodedData['message'] != null) {
        message =
            decodedData['message'].toString();
      } else if (decodedData['error'] != null) {
        message =
            decodedData['error'].toString();
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
    _httpClient.close(
      force: true,
    );
  }
}