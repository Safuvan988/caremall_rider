class ApiUrls {
  // Base URL
  static const String baseURL = 'https://test.api.caremallonline.com/';

  // Auth
  static const String sendOtp = '${baseURL}api/v1/user/auth/send-otp';
  static const String login = '${baseURL}api/v1/user/auth/login';
  static const String verifyOtp = '${baseURL}api/v1/user/auth/verify-otp';
  static const String register = '${baseURL}api/v1/user/auth/register';
  static const String resendOtp = '${baseURL}api/v1/user/auth/resend-otp';
  static const String logout = '${baseURL}api/v1/user/auth/logout';
}
