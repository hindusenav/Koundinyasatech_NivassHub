// lib/services/forgot_password/forgot_password_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/api_endpoints.dart';
import '../../services/base_api.dart';
import 'models/forgot_password_models.dart';

/// Service class for all Forgot Password related API calls
class ForgotPasswordService {
  final Dio _dio;

  ForgotPasswordService({Dio? dio}) : _dio = dio ?? BaseApi.createDio();

  // ==================== 1. GENERATE OTP ====================
  Future<ForgotPasswordResponse> generateOTP({
    required String umail,
    String? contCode,
    String? action,
  }) async {
    try {
      final request = ForgotPasswordRequest(
        umail: umail,
        contCode: contCode,
        action: action,
      );

      debugPrint('[ForgotPassword] Generating OTP for: $umail');
      debugPrint('[ForgotPassword] Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );

      debugPrint('[ForgotPassword] Response: ${response.data}');

      if (response.statusCode == 200) {
        return ForgotPasswordResponse.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== 2. VERIFY OTP ====================
  Future<VerifyOtpResponse> verifyOTP({
    required String otpToken,
    required String otp,
    required String identifier,
    required String otpType,
  }) async {
    try {
      final request = VerifyOtpRequest(
        otpToken: otpToken,
        otp: otp,
        identifier: identifier,
        otpType: otpType,
      );

      debugPrint('[ForgotPassword] Verifying OTP');
      debugPrint('[ForgotPassword] Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: request.toJson(),
      );

      debugPrint('[ForgotPassword] Response: ${response.data}');

      if (response.statusCode == 200) {
        return VerifyOtpResponse.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== 3. UPDATE PASSWORD ====================
  Future<UpdatePasswordResponse> updatePassword({
    required String fpToken,
    required String newPassword,
  }) async {
    try {
      final request = UpdatePasswordRequest(
        fpToken: fpToken,
        newPassword: newPassword,
      );

      debugPrint('[ForgotPassword] Updating password');
      debugPrint('[ForgotPassword] Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.updatePassword,
        data: request.toJson(),
      );

      debugPrint('[ForgotPassword] Response: ${response.data}');

      if (response.statusCode == 200) {
        return UpdatePasswordResponse.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== 4. GET COUNTRY CODES ====================
  Future<CountryListResponse> getCountryCodes() async {
    try {
      debugPrint('[ForgotPassword] Fetching country codes');

      final response = await _dio.get(ApiEndpoints.userRegistration);

      debugPrint('[ForgotPassword] Response: ${response.data}');

      if (response.statusCode == 200) {
        return CountryListResponse.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== ERROR HANDLING ====================
  dynamic _handleError(Response response) {
    final data = response.data;
    final message =
        data?['Message'] ?? data?['message'] ?? 'Something went wrong';
    final status = response.statusCode ?? 500;

    debugPrint('[ForgotPassword] Error $status: $message');

    return ForgotPasswordException(
      statusCode: status,
      message: message,
      data: data,
    );
  }

  dynamic _handleDioError(DioException e) {
    debugPrint('[ForgotPassword] Dio Error: ${e.message}');

    if (e.response != null) {
      return _handleError(e.response!);
    }

    String message = 'Network error. Please check your connection.';
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Connection timeout. Please try again.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection. Please check your network.';
    }

    return ForgotPasswordException(statusCode: 0, message: message, data: null);
  }
}

/// Custom exception for Forgot Password errors
class ForgotPasswordException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? data;

  ForgotPasswordException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ForgotPasswordException: $statusCode - $message';
}
