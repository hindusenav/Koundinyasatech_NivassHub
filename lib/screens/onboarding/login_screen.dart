
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/utils/flag_emoji.dart';

import 'dummy_account_screen.dart';

class CountryCode {
  final String name;
  final String shortCode;
  final String callingCode;
  final String flagEmoji;
  final int maxDigits;
  final String mobilePattern;

  const CountryCode({
    required this.name,
    required this.shortCode,
    required this.callingCode,
    required this.maxDigits,
    required this.mobilePattern,
    this.flagEmoji = '🌐',
  });

  factory CountryCode.fromLocationNode(LocationNode node) {
    final code = node.id.toUpperCase();
    final rule = countryRules[code];

    return CountryCode(
      name: node.name,
      shortCode: code,
      callingCode: node.dialCode ?? '',
      flagEmoji: node.flagEmoji ?? flagEmojiFromIso(node.id) ?? '🌐',
      maxDigits: rule?.maxDigits ?? 15,
      mobilePattern: rule?.mobilePattern ?? r'^\d{4,15}$',
    );
  }

  static const Map<String, CountryCode> countryRules = {
    'IN': CountryCode(
      name: 'India',
      shortCode: 'IN',
      callingCode: '+91',
      maxDigits: 10,
      mobilePattern: r'^[6-9]\d{9}$',
    ),
    'US': CountryCode(
      name: 'United States',
      shortCode: 'US',
      callingCode: '+1',
      maxDigits: 10,
      mobilePattern: r'^[2-9]\d{2}[2-9]\d{6}$',
    ),
    'CA': CountryCode(
      name: 'Canada',
      shortCode: 'CA',
      callingCode: '+1',
      maxDigits: 10,
      mobilePattern: r'^[2-9]\d{2}[2-9]\d{6}$',
    ),
    'GB': CountryCode(
      name: 'United Kingdom',
      shortCode: 'GB',
      callingCode: '+44',
      maxDigits: 10,
      mobilePattern: r'^7\d{9}$',
    ),
    'AE': CountryCode(
      name: 'United Arab Emirates',
      shortCode: 'AE',
      callingCode: '+971',
      maxDigits: 9,
      mobilePattern: r'^5\d{8}$',
    ),
    'QA': CountryCode(
      name: 'Qatar',
      shortCode: 'QA',
      callingCode: '+974',
      maxDigits: 8,
      mobilePattern: r'^[3567]\d{7}$',
    ),
    'AU': CountryCode(
      name: 'Australia',
      shortCode: 'AU',
      callingCode: '+61',
      maxDigits: 9,
      mobilePattern: r'^4\d{8}$',
    ),
    'SG': CountryCode(
      name: 'Singapore',
      shortCode: 'SG',
      callingCode: '+65',
      maxDigits: 8,
      mobilePattern: r'^[89]\d{7}$',
    ),
  };
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color navy = Color(0xFF0E2543);
  static const Color orange = Color(0xFFFC7118);
  static const Color lightText = Color(0xFFF1F8FF);

  late final VideoPlayerController _videoController;

  final TextEditingController _mobileController =
      TextEditingController();

  final FocusNode _mobileFocusNode = FocusNode();

  bool _videoReady = false;
  bool _countriesLoading = true;

  List<CountryCode> _countries = [];
  CountryCode? _selectedCountry;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
    );

    _videoController = VideoPlayerController.asset(
      'assets/videos/onboarding_screen5.mp4',
    );

    _initializeVideo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCountries();
      }
    });
  }

  Future<void> _loadCountries() async {
    if (!mounted) return;

    setState(() => _countriesLoading = true);

    try {
      debugPrint('[LoginScreen] Calling GET /country-codes');

      final response =
          await context.read<CountryServiceBase>().getCountries();

      debugPrint('[LoginScreen] Response data: ${response.data}');
      debugPrint('[LoginScreen] Response error: ${response.error}');

      if (!mounted) return;

      final nodes = response.data ?? <LocationNode>[];

      debugPrint('[LoginScreen] Parsed country count: ${nodes.length}');

      for (final node in nodes.take(5)) {
        debugPrint(
          '[LoginScreen] Country: ${node.name}, '
          'code: ${node.id}, calling code: ${node.dialCode}',
        );
      }

      final countries = nodes
          .map(CountryCode.fromLocationNode)
          .where(
            (country) =>
                country.name.trim().isNotEmpty &&
                country.shortCode.trim().isNotEmpty &&
                country.callingCode.trim().isNotEmpty,
          )
          .toList(growable: false);

      CountryCode? selected;

      for (final country in countries) {
        if (country.shortCode == 'IN') {
          selected = country;
          break;
        }
      }

      selected ??= countries.isNotEmpty ? countries.first : null;

      setState(() {
        _countries = countries;
        _selectedCountry = selected;
        _countriesLoading = false;
      });

      if (countries.isEmpty) {
        debugPrint(
          '[LoginScreen] No usable countries found. '
          'Parsed nodes: ${nodes.length}',
        );
        _showMessage('No countries were returned. Please retry.');
      } else {
        debugPrint(
          '[LoginScreen] Successfully loaded ${countries.length} countries.',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('[LoginScreen] Country API exception: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _countries = [];
        _selectedCountry = null;
        _countriesLoading = false;
      });

      _showMessage(
        'Could not load country codes. Check your connection.',
      );
    }
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      await _videoController.setLooping(true);
      await _videoController.setVolume(0);
      await _videoController.play();

      if (!mounted) return;

      setState(() {
        _videoReady = true;
      });
    } catch (error, stackTrace) {
      debugPrint('Login background video failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  void _openDummyAccount() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DummyAccountScreen(),
      ),
    );
  }

  String? _validateMobileNumber(String mobile) {
    if (mobile.isEmpty) {
      return 'Please enter your mobile number.';
    }

    if (!RegExp(r'^\d+$').hasMatch(mobile)) {
      return 'Please enter digits only.';
    }

    final country = _selectedCountry;

    if (country == null) {
      return 'Country codes are unavailable. Please retry.';
    }

    if (mobile.length > country.maxDigits) {
      return 'The number is too long for the selected country.';
    }

    if (!RegExp(country.mobilePattern).hasMatch(mobile)) {
      switch (country.shortCode) {
        case 'IN':
          return 'Enter a valid 10-digit Indian mobile number.';
        case 'US':
        case 'CA':
          return 'Enter a valid 10-digit US/Canadian number.';
        case 'GB':
          return 'Enter a valid 10-digit UK mobile number starting with 7.';
        case 'AE':
          return 'Enter a valid 9-digit UAE mobile number starting with 5.';
        case 'QA':
          return 'Enter a valid 8-digit Qatar mobile number.';
        case 'AU':
          return 'Enter a valid 9-digit Australian mobile number starting with 4.';
        case 'SG':
          return 'Enter a valid 8-digit Singapore mobile number starting with 8 or 9.';
        default:
          return 'Enter a valid mobile number for the selected country.';
      }
    }

    return null;
  }

  void _handleLogin() {
    final mobile = _mobileController.text.trim();
    final validationMessage = _validateMobileNumber(mobile);

    if (validationMessage != null) {
      _showMessage(validationMessage);
      _mobileFocusNode.requestFocus();
      return;
    }

    // Temporary navigation until OTP integration.
    _openDummyAccount();
  }

  void _handleRegistration() {
    _openDummyAccount();
  }

  void _handleCountryChanged(CountryCode? country) {
    if (country == null) return;

    setState(() {
      _selectedCountry = country;
    });

    _mobileController.clear();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _mobileController.dispose();
    _mobileFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      extendBody: true,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 440,
            height: 956,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: navy),

                  // Background video.
                  Positioned(
                    left: -1,
                    top: 340,
                    width: 442,
                    height: 616,
                    child: _videoReady
                        ? ClipRect(
                            child: Opacity(
                              opacity: 0.30,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: _videoController.value.size.width,
                                  height: _videoController.value.size.height,
                                  child: VideoPlayer(_videoController),
                                ),
                              ),
                            ),
                          )
                        : const ColoredBox(color: navy),
                  ),

                  // Original video gradient.
                  Positioned(
                    left: 0,
                    top: 340,
                    width: 440,
                    height: 616,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              navy,
                              const Color(0x000E2543),
                              const Color(0x000E2543),
                              navy,
                            ],
                            stops: const [0.0, 0.18, 0.78, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Logo.
                  Positioned(
                    left: 95,
                    top: 135,
                    width: 250,
                    height: 250,
                    child: Image.asset(
                      'assets/images/blackLogo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Heading.
                  const Positioned(
                    left: 20,
                    top: 400,
                    width: 400,
                    child: Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'DMSans',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),

                  // Subtitle.
                  const Positioned(
                    left: 30,
                    top: 445,
                    width: 380,
                    height: 28,
                    child: Text(
                      'Login to access your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lightText,
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Country dropdown and phone field.
                  Positioned(
                    left: 20,
                    top: 590,
                    width: 400,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: orange),
                      ),
                      padding: const EdgeInsets.only(left: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 82,
                            child: _countriesLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: orange,
                                      ),
                                    ),
                                  )
                                : _countries.isEmpty
                                    ? IconButton(
                                        tooltip: 'Retry loading countries',
                                        onPressed: _loadCountries,
                                        icon: const Icon(
                                          Icons.refresh,
                                          color: Color(0xFF0B1625),
                                        ),
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton<CountryCode>(
                                          value: _selectedCountry,
                                          isExpanded: true,
                                          menuMaxHeight: 420,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            size: 19,
                                          ),
                                          onChanged: _handleCountryChanged,
                                          selectedItemBuilder: (context) {
                                            return _countries.map((country) {
                                              return Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      country.flagEmoji,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        country.callingCode,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Color(0xFF0B1625),
                                                          fontFamily: 'DMSans',
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList();
                                          },
                                          items: _countries.map((country) {
                                            return DropdownMenuItem<CountryCode>(
                                              value: country,
                                              child: Text(
                                                '${country.flagEmoji} ${country.name} (${country.callingCode})',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Color(0xFF0B1625),
                                                  fontFamily: 'DMSans',
                                                  fontSize: 13,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                          ),

                          const SizedBox(
                            height: 25,
                            child: VerticalDivider(
                              width: 1,
                              color: Color(0xFF9EA1A8),
                            ),
                          ),

                          Expanded(
                            child: TextField(
                              controller: _mobileController,
                              focusNode: _mobileFocusNode,
                              keyboardType: TextInputType.phone,
                              maxLength: _selectedCountry?.maxDigits ?? 15,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  _selectedCountry?.maxDigits ?? 15,
                                ),
                              ],
                              style: const TextStyle(
                                color: Color(0xFF161D2A),
                                fontFamily: 'DMSans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: 'Enter mobile number',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9EA1A8),
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),

                  // Login with OTP button.
                  Positioned(
                    left: 20,
                    top: 669,
                    width: 400,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _countriesLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            orange.withValues(alpha: 0.6),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone_android,
                            size: 21,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Login with OTP',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Create account prompt.
                  Positioned(
                    left: 10,
                    top: 795,
                    width: 400,
                    height: 35,
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'New to Nivaas Hub? ',
                            style: TextStyle(
                              color: Color(0xFF9AA7B5),
                              fontFamily: 'DMSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: _handleRegistration,
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                color: orange,
                                fontFamily: 'DMSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
