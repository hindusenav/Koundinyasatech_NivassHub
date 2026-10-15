
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/services/country/country_service.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

import 'screens/onboarding/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final CountryServiceBase countryService = CountryService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        Provider<CountryServiceBase>.value(value: countryService),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      ),
    ),
  );
}
