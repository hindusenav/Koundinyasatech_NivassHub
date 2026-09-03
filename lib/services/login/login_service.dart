import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base_api.dart';
import '../api_endpoints.dart';

/// Response model for login
class LoginResponse {
  final int errorCode;
  final String errorMsg;
  final String? refreshToken;

  LoginResponse({
    required this.errorCode,
    required this.errorMsg,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      errorCode: json['ErrorCode'] as int? ?? 500,
      errorMsg: json['ErrorMsg'] as String? ?? 'Unknown error occurred',
      refreshToken: json['RefreshToken'] as String?,
    );
  }

  bool get isSuccess => errorCode == 200;
}

/// Response model for countries
class CountryResponse {
  final List<Country> countries;

  CountryResponse({required this.countries});

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    final List<Country> countries = [];
    if (json['ActiveCountries'] != null) {
      final List<dynamic> activeCountries = json['ActiveCountries'];
      countries.addAll(
        activeCountries.map(
          (country) => Country.fromJson(country as Map<String, dynamic>),
        ),
      );
    }
    return CountryResponse(countries: countries);
  }
}

/// Country model
class Country {
  final String callingCode;
  final String countryName;
  final String shortCode;

  Country({
    required this.callingCode,
    required this.countryName,
    required this.shortCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      callingCode: json['callingCode']?.toString() ?? '',
      countryName: json['countryName']?.toString() ?? '',
      shortCode: json['shortCode']?.toString() ?? '',
    );
  }

  String get displayName => '$countryName ${_getFlagEmoji(shortCode)}';

  /// Convert country code to flag emoji
  String _getFlagEmoji(String shortCode) {
    if (shortCode.isEmpty) return '🌍';
    final upper = shortCode.toUpperCase();
    if (upper.length != 2) return '🌍';
    const offset = 0x1F1E6 - 65;
    final first = upper.codeUnitAt(0) + offset;
    final second = upper.codeUnitAt(1) + offset;
    return String.fromCharCodes([first, second]);
  }
}

/// Login request model
class LoginRequest {
  final String emailOrPhone;
  final String password;
  final String? countryCode;

  LoginRequest({
    required this.emailOrPhone,
    required this.password,
    this.countryCode,
  });

  Map<String, dynamic> toJson() {
    return {'umail': emailOrPhone, 'pwd': password, 'cont_code': countryCode};
  }
}

/// Login service for handling authentication
class LoginService {
  final Dio _dio;
  static const String _tokenKey = 'auth_token';

  LoginService() : _dio = BaseApi.createDio();

  /// Get Dio instance
  Dio get dio => _dio;

  /// Fetch countries from API
  Future<CountryResponse> fetchCountries() async {
    try {
      final response = await _dio.get(ApiEndpoints.countryCodes);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CountryResponse.fromJson(data);
      } else {
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to fetch countries',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Login with email or phone
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final loginResponse = LoginResponse.fromJson(data);

        // Save token if login successful
        if (loginResponse.isSuccess && loginResponse.refreshToken != null) {
          await _saveToken(loginResponse.refreshToken!);
        }

        return loginResponse;
      } else {
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: 'Login failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Login with Email
  Future<LoginResponse> loginWithEmail(String email, String password) async {
    final request = LoginRequest(
      emailOrPhone: email,
      password: password,
      countryCode: null,
    );
    return login(request);
  }

  /// Login with Phone
  Future<LoginResponse> loginWithPhone(
    String phoneNumber,
    String password,
    String countryCode,
  ) async {
    final request = LoginRequest(
      emailOrPhone: phoneNumber,
      password: password,
      countryCode: countryCode,
    );
    return login(request);
  }

  /// Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      debugPrint('[LoginService] Token saved successfully');
    } catch (e) {
      debugPrint('[LoginService] Error saving token: $e');
      rethrow;
    }
  }

  /// Get stored token
  Future<String?> getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      debugPrint('[LoginService] Error getting token: $e');
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear stored token (logout)
  Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      debugPrint('[LoginService] Token cleared successfully');
    } catch (e) {
      debugPrint('[LoginService] Error clearing token: $e');
      rethrow;
    }
  }

  /// Handle Dio exceptions with proper error messages
  ApiException _handleDioError(DioException e) {
    String message = 'Network error. Please check your connection.';
    int statusCode = 500;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please try again.';
        statusCode = 408;
        break;

      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        statusCode = 503;
        break;

      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        statusCode = 499;
        break;

      case DioExceptionType.badResponse:
        statusCode = e.response?.statusCode ?? 500;
        // Try to parse error message from response
        try {
          final data = e.response?.data as Map<String, dynamic>?;
          if (data != null && data['ErrorMsg'] != null) {
            message = data['ErrorMsg'] as String;
          } else {
            message = 'Server error. Please try again.';
          }
        } catch (_) {
          message = 'Server error. Please try again.';
        }
        break;

      case DioExceptionType.badCertificate:
        message = 'Security certificate error.';
        statusCode = 495;
        break;

      default:
        message = 'An unexpected error occurred. Please try again.';
        statusCode = 500;
    }

    return ApiException(
      statusCode: statusCode,
      message: message,
      originalError: e,
    );
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic originalError;

  ApiException({
    required this.statusCode,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}
