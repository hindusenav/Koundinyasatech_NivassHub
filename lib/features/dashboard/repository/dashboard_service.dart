import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_service.dart';
import '../models/dashboard_summary_model.dart';

class DashboardService extends ApiService {
  const DashboardService(super.client);

  Future<ApiResponse<DashboardSummaryModel>> getSummary() {
    return handleRequest(
      () => client.get(ApiEndpoints.dashboardSummary),
      (json) => DashboardSummaryModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
