// lib/services/forgot_password/models/forgot_password_models.dart

/// Request model for forgot password OTP generation
class ForgotPasswordRequest {
  final String umail;
  final String? contCode;
  final String? action;

  ForgotPasswordRequest({required this.umail, this.contCode, this.action});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'umail': umail};
    if (contCode != null && contCode!.isNotEmpty) {
      map['cont_code'] = contCode;
    }
    if (action != null && action!.isNotEmpty) {
      map['action'] = action;
    }
    return map;
  }
}

/// Response model for forgot password OTP generation
class ForgotPasswordResponse {
  final int status;
  final bool success;
  final String? otp;
  final String message;
  final String? otpKey;
  final String? identifier;
  final String? otpType;

  ForgotPasswordResponse({
    required this.status,
    required this.success,
    this.otp,
    required this.message,
    this.otpKey,
    this.identifier,
    this.otpType,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['Status'] ?? json['statusCode'] ?? 0,
      success: json['Success'] ?? json['success'] ?? false,
      otp: json['OTP'],
      message: json['Message'] ?? json['message'] ?? '',
      otpKey: json['OtpKey'],
      identifier: json['identifier'],
      otpType: json['OTPType'],
    );
  }
}

/// Request model for OTP verification
class VerifyOtpRequest {
  final String otpToken;
  final String otp;
  final String identifier;
  final String otpType;

  VerifyOtpRequest({
    required this.otpToken,
    required this.otp,
    required this.identifier,
    required this.otpType,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp_token': otpToken,
      'otp': otp,
      'identifier': identifier,
      'otp_type': otpType,
    };
  }
}

/// Response model for OTP verification
class VerifyOtpResponse {
  final int statusCode;
  final bool success;
  final String? fpToken;
  final String message;

  VerifyOtpResponse({
    required this.statusCode,
    required this.success,
    this.fpToken,
    required this.message,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      statusCode: json['statusCode'] ?? json['Status'] ?? 0,
      success: json['success'] ?? json['Success'] ?? false,
      fpToken: json['FP_Token'],
      message: json['message'] ?? json['Message'] ?? '',
    );
  }
}

/// Request model for password update
class UpdatePasswordRequest {
  final String fpToken;
  final String newPassword;

  UpdatePasswordRequest({required this.fpToken, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'FP_Token': fpToken, 'new_pwd': newPassword};
  }
}

/// Response model for password update
class UpdatePasswordResponse {
  final int httpStatus;
  final String message;

  UpdatePasswordResponse({required this.httpStatus, required this.message});

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponse(
      httpStatus: json['HttpStatus'] ?? json['statusCode'] ?? 0,
      message: json['Message'] ?? json['message'] ?? '',
    );
  }
}

/// Country model for registration
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
      callingCode: json['callingCode'] ?? '',
      countryName: json['countryName'] ?? '',
      shortCode: json['shortCode'] ?? '',
    );
  }
}

/// Country list response
class CountryListResponse {
  final int statusCode;
  final String statusMessage;
  final int totalCountries;
  final List<Country> activeCountries;

  CountryListResponse({
    required this.statusCode,
    required this.statusMessage,
    required this.totalCountries,
    required this.activeCountries,
  });

  factory CountryListResponse.fromJson(Map<String, dynamic> json) {
    final countries = <Country>[];
    if (json['ActiveCountries'] != null) {
      final list = json['ActiveCountries'] as List;
      countries.addAll(list.map((e) => Country.fromJson(e)));
    }
    return CountryListResponse(
      statusCode: json['StatusCode'] ?? 0,
      statusMessage: json['StatusMessage'] ?? '',
      totalCountries: json['TotalCountries'] ?? 0,
      activeCountries: countries,
    );
  }
}
