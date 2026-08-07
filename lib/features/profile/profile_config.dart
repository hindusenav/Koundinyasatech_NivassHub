/// No published base URL exists yet for the NivasHub API contract (see the
/// contract's cover note), so Profile defaults to its mock implementation —
/// the same reason `auth`/`dashboard` default `useMockApi`/`useMockHomeApi`
/// to `true` today. Flip this to `false` once the backend is live;
/// `main.dart` will construct the real `ProfileService` instead, with no
/// other code changes needed anywhere.
const bool useMockProfileApi = true;
