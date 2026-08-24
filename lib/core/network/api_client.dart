import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Custom Exception for API errors
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
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

/// Custom Exception for Network/Connection errors
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Built-in API Client using standard dart:io HttpClient
class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final HttpClient _httpClient;

  ApiClient({
    this.baseUrl = '',
    this.timeout = const Duration(seconds: 15),
  }) : _httpClient = HttpClient() {
    _httpClient.connectionTimeout = timeout;
  }

  // ===========================================================================
  // HTTP GET
  // ===========================================================================
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
      queryParams: queryParams,
    );
  }

  // ===========================================================================
  // HTTP POST
  // ===========================================================================
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===========================================================================
  // HTTP PUT
  // ===========================================================================
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _sendRequest(
      method: 'PUT',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===========================================================================
  // HTTP DELETE
  // ===========================================================================
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _sendRequest(
      method: 'DELETE',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  // ===========================================================================
  // Core Request Handler
  // ===========================================================================
  Future<dynamic> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final HttpClientRequest request = await _httpClient.openUrl(method, uri).timeout(timeout);

      // Default Headers
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      // Custom Headers
      headers?.forEach((key, value) {
        request.headers.set(key, value);
      });

      // Write Request Body if present
      if (body != null) {
        final jsonString = body is String ? body : jsonEncode(body);
        request.write(jsonString);
      }

      // Close and wait for response
      final HttpClientResponse response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      return _processResponse(response.statusCode, responseBody);
    } on SocketException catch (e) {
      throw NetworkException('No Internet connection or server unreachable: ${e.message}');
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on HttpException catch (e) {
      throw NetworkException('HTTP Error: ${e.message}');
    } catch (e) {
      if (e is ApiException || e is NetworkException) rethrow;
      throw NetworkException('Unexpected error: $e');
    }
  }

  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParams) {
    final fullUrl = baseUrl.isEmpty ? endpoint : '$baseUrl$endpoint';
    final uri = Uri.parse(fullUrl);

    if (queryParams == null || queryParams.isEmpty) {
      return uri;
    }

    final stringParams = queryParams.map((k, v) => MapEntry(k, v.toString()));
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...stringParams,
    });
  }

  dynamic _processResponse(int statusCode, String responseBody) {
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
    } else {
      throw ApiException(
        statusCode: statusCode,
        message: decodedData is Map && decodedData['message'] != null
            ? decodedData['message'].toString()
            : 'HTTP Error $statusCode',
        data: decodedData,
      );
    }
  }

  void close() {
    _httpClient.close(force: true);
  }
}
