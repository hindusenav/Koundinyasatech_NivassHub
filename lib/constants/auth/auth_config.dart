/// `checkUserExists`/`loginUser` (via `PartialRealAuthEntryService`) and the
/// forgot-password flow now call the real, documented backend endpoints.
/// `createUser`/`generateAccessToken` stay mocked regardless of this flag —
/// see `PartialRealAuthEntryService` — since no backend contract exists for
/// registration submit or the KYC-approval access token.
const bool useMockApi = false;
