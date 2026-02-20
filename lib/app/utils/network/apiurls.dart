class ApiUrls {
  // Base URL
  // Use 10.0.2.2 for Android Emulator to access host localhost
  // Use Your_PC_IP_Address for Physical Device (e.g., 192.168.1.x)
  static const String baseURL = 'http://192.168.1.5:3000';

  // Auth
  static const String sendOtp = '$baseURL/api/v1/rider/auth/send-otp';
  static const String login = '$baseURL/api/v1/rider/auth/login';
  static const String verifyOtp = '$baseURL/api/v1/rider/auth/verify-otp';
  static const String register = '$baseURL/api/v1/rider/auth/register';
  static const String resendOtp = '$baseURL/api/v1/rider/auth/resend-otp';
  static const String logout = '$baseURL/api/v1/rider/auth/logout';

  // Kyc
  static const String kycSubmit = '$baseURL/api/v1/rider/kyc/submit';
  static const String kycStatus = '$baseURL/api/v1/rider/kyc/status';

  // Routes
  static const String todayRoute = '$baseURL/api/v1/rider/routes/today';
  static const String riderStatus = '$baseURL/api/v1/rider/status';

  // Orders
  static const String orderDetails =
      '$baseURL/api/v1/rider/orders'; // append /{orderId}
  static const String orderFailed =
      '$baseURL/api/v1/rider/orders'; // append /{orderId}/failed
  static const String sendDeliveryOtp =
      '$baseURL/api/v1/rider/orders'; // append /{orderId}/send-otp
  static const String completeDelivery =
      '$baseURL/api/v1/rider/orders'; // append /{orderId}/complete

  // Profile
  static const String getProfile = '$baseURL/api/v1/rider/profile';
  static const String updateProfile = '$baseURL/api/v1/rider/profile';
}
