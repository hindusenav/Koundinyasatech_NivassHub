import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../network/api_client.dart';

class AppProviders {
  AppProviders._();

  static final ApiClient _apiClient = ApiClient();

  static List<SingleChildWidget> providers = [
    Provider<ApiClient>.value(value: _apiClient),

    ChangeNotifierProvider<NoticesProvider>(
      create: (_) => NoticesProvider(apiClient: _apiClient),
    ),
  ];
}
