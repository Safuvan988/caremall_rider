class ApiUrls {
  // Base URL
  // Use 10.0.2.2 for Android Emulator to access host localhost
  // Use Your_PC_IP_Address for Physical Device (e.g., 192.168.1.x)
  static const String baseURL = 'http://192.168.1.4:3000';

  // Auth
  static const String sendOtp =
      '$baseURL/api/v1/rider/auth/send-otp'; // POST – send OTP to rider
  static const String login =
      '$baseURL/api/v1/rider/auth/login'; // POST – login with phone and OTP
  static const String verifyOtp =
      '$baseURL/api/v1/rider/auth/verify-otp'; // POST – verify OTP
  static const String register =
      '$baseURL/api/v1/rider/auth/register'; // POST – register new rider
  static const String resendOtp =
      '$baseURL/api/v1/rider/auth/resend-otp'; // POST – resend OTP
  static const String logout =
      '$baseURL/api/v1/rider/auth/logout'; // POST – logout rider
  //
  // Kyc
  static const String kycSubmit =
      '$baseURL/api/v1/rider/kyc/submit'; // POST – submit kyc
  static const String kycStatus =
      '$baseURL/api/v1/rider/kyc/status'; // GET – get kyc status

  // Routes
  static const String todayRoute =
      '$baseURL/api/v1/rider/routes/today'; // GET – today's route with ?lat=&lng=

  // Orders
  static const String deliveryOrders =
      '$baseURL/api/v1/rider/delivery/orders'; // GET – list all assigned orders
  static String orderDetail(String id) =>
      '$baseURL/api/v1/rider/delivery/orders/$id'; // GET – single order detail
  static String orderUpdateStatus(String id) =>
      '$baseURL/api/v1/rider/delivery/orders/$id/status'; // PATCH – update order status
  static String orderUploadPhoto(String id) =>
      '$baseURL/api/v1/rider/delivery/orders/$id/upload-photo'; // POST – upload delivery photo
  static String orderFailed(String id) =>
      '$baseURL/api/v1/rider/delivery/orders/$id/failed'; // POST – report delivery failure
  static String orderSendOTP(String id) =>
      '$baseURL/api/v1/rider/delivery/orders/$id/send-otp'; // POST – send delivery OTP
  static String orderVerifyOTP(String id) =>
      '$baseURL/api/v1/rider/delivery/orders/$id/complete'; // POST – verify OTP and complete

  // Returns
  static const String returnsOrders =
      '$baseURL/api/v1/rider/returns/'; // GET – return orders list
  static String returnDetail(String id) =>
      '$baseURL/api/v1/rider/returns/$id'; // GET – single return order
  static String returnUpdateStatus(String id) =>
      '$baseURL/api/v1/rider/returns/$id/status'; // PATCH – update return status
  static String returnUploadPhoto(String id) =>
      '$baseURL/api/v1/rider/returns/$id/upload-photo'; // POST – upload return photo

  // Wallet
  static const String wallet =
      '$baseURL/api/v1/rider/wallet'; // GET – get wallet
  static const String withdraw =
      '$baseURL/api/v1/rider/wallet/withdraw'; // POST – withdraw
  static const String withdrawalRequests =
      '$baseURL/api/v1/rider/wallet/requests'; // GET – get withdrawal requests

  // Profile
  // static const String getProfile = '$baseURL/api/v1/rider/profile';
  // static const String updateProfile = '$baseURL/api/v1/rider/profile';
}
