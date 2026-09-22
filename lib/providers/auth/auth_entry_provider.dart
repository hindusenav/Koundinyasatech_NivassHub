import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

enum AuthEntryStatus { idle, checking, existingUser, newUser, error }

/// Backs the authentication entry screen: pick a channel, type an
/// identifier, find out whether the account exists.
///
/// Screen-scoped. A stale `existingUser` surviving a back-navigation is
/// precisely the class of bug `AuthProvider._resetOtpFlowState()` exists
/// to paper over in the older flow; scoping the provider to the route
/// removes it instead of guarding against it.
class AuthEntryProvider extends ChangeNotifier {
  AuthEntryProvider({
    required AuthEntryServiceBase authService,
    required CountryServiceBase countryService,
    AuthChannel initialChannel = AuthChannel.mobile,
  }) : _authService = authService,
       _countryService = countryService,
       _channel = initialChannel;

  final AuthEntryServiceBase _authService;
  final CountryServiceBase _countryService;

  AuthEntryStatus _status = AuthEntryStatus.idle;

  /// Seeded through the constructor rather than by calling [setChannel]
  /// from the screen's `initState`: that notifies listeners synchronously,
  /// which is illegal while the frame is still building.
  AuthChannel _channel;
  String? _errorMessage;
  String? _maskedIdentifier;

  List<LocationNode> _dialCodes = const [];
  LocationNode? _selectedCountry;
  bool _isLoadingDialCodes = false;
  String? _dialCodesError;

  AuthEntryStatus get status => _status;
  AuthChannel get channel => _channel;
  String? get errorMessage => _errorMessage;
  String? get maskedIdentifier => _maskedIdentifier;

  bool get isChecking => _status == AuthEntryStatus.checking;
  bool get isMobileMode => _channel == AuthChannel.mobile;

  List<LocationNode> get dialCodes => _dialCodes;
  LocationNode? get selectedCountry => _selectedCountry;
  bool get isLoadingDialCodes => _isLoadingDialCodes;

  /// Set when the last [loadCountryCodes] call came back with no usable
  /// countries — either a real request failure, or a request that
  /// succeeded but yielded zero parsed rows (a field-name mismatch
  /// between the backend and this contract). Lets the picker offer Retry
  /// instead of sitting permanently disabled with no explanation.
  String? get dialCodesError => _dialCodesError;

  /// `null` until the country list arrives, which is what the "country
  /// code is required" validation keys off.
  String? get countryCode => _selectedCountry?.dialCode;

  /// Loads the dial codes and pre-selects India, matching the existing
  /// screens' `+91` default.
  Future<void> loadCountryCodes() async {
    _isLoadingDialCodes = true;
    _dialCodesError = null;
    notifyListeners();

    final response = await _countryService.getCountries();
    if (response.isSuccess && response.data != null) {
      _dialCodes = response.data!
          .where((c) => (c.dialCode ?? '').isNotEmpty)
          .toList(growable: false);
      _selectedCountry ??= _defaultCountry(_dialCodes);
      if (_dialCodes.isEmpty) {
        _dialCodesError = 'Could not load country codes. Tap to retry.';
      }
    } else {
      _dialCodesError = response.message ?? 'Could not load country codes. Tap to retry.';
    }

    _isLoadingDialCodes = false;
    notifyListeners();
  }

  /// Pre-selects `+91`, matching the fixed badge the previous auth
  /// screens used. Returns `null` on an empty list rather than
  /// substituting a placeholder country, so the "country code is
  /// required" validation fires instead of sending a blank dial code.
  static LocationNode? _defaultCountry(List<LocationNode> countries) {
    for (final country in countries) {
      if (country.dialCode == '+91') return country;
    }
    return countries.isEmpty ? null : countries.first;
  }

  void setChannel(AuthChannel channel) {
    if (_channel == channel) return;
    _channel = channel;
    _errorMessage = null;
    _status = AuthEntryStatus.idle;
    notifyListeners();
  }

  void setCountry(LocationNode country) {
    _selectedCountry = country;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears a previous failure as soon as the user edits the field, so a
  /// stale error never sits under a value it no longer describes.
  void clearError() {
    if (_errorMessage == null && _status != AuthEntryStatus.error) return;
    _errorMessage = null;
    _status = AuthEntryStatus.idle;
    notifyListeners();
  }

  /// Returns the built identifier on success, or `null` on failure — the
  /// screen needs the value to pass on as route arguments, and `status`
  /// tells it which branch to take.
  Future<AuthIdentifier?> checkUserExists(String rawIdentifier) async {
    final identifier = AuthIdentifier(
      raw: rawIdentifier,
      channel: _channel,
      countryCode: _channel == AuthChannel.mobile ? countryCode : null,
    );

    _status = AuthEntryStatus.checking;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.checkUserExists(
      CheckUserExistsRequest(identifier: identifier),
    );

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      _maskedIdentifier = data.maskedIdentifier ?? identifier.masked;
      _status = data.userExists
          ? AuthEntryStatus.existingUser
          : AuthEntryStatus.newUser;
      notifyListeners();
      return identifier;
    }

    _errorMessage = response.message ?? KycStrings.genericError;
    _status = AuthEntryStatus.error;
    notifyListeners();
    return null;
  }
}
