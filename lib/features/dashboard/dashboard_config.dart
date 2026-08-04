/// Single switch point between [MockHomeApiService] and the real
/// [HomeApiService] for the Home Screen API contract, set at the
/// composition root (`main.dart`). Flip to `false` once the backend at
/// `ApiEndpoints.baseUrl` is available — no other code needs to change.
const bool useMockHomeApi = true;
