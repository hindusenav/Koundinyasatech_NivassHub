/// Success payload for POST /auth/forgot-password/update-password.
///
/// This endpoint's envelope (`{HttpStatus, Message}`) carries no `success`
/// boolean at all and no data fields beyond a message — `HttpStatus == 200`
/// IS success. [ForgotPasswordService.updatePassword] checks that before
/// this class is ever constructed, so this is a trivial marker with no
/// fields of its own.
class ForgotPasswordUpdatePasswordResponseData {
  const ForgotPasswordUpdatePasswordResponseData();
}
