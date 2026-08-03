import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_providers.dart';
import 'features/notices/screens/notices_screen.dart';
import 'core/network/api_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NivassHubApp());
}

class NivassHubApp extends StatelessWidget {
  const NivassHubApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NivassHub',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: NoticesScreen(apiClient: ApiClient()),
      ),
    );
  }
}
