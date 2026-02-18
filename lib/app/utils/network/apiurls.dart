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

  // // User / Profile
  // static const String userProfile = '${baseURL}api/v1/user/profile';
  // static const String updateProfile = '${baseURL}api/v1/user/profile/update';
  // static const String updateProfilePic =
  //     '${baseURL}api/v1/user/profile/update-picture';

  // // Home / Dashboard
  // static const String home = '${baseURL}api/v1/rider/home';
  // static const String notifications = '${baseURL}api/v1/rider/notifications';

  // // Orders
  // static const String orders = '${baseURL}api/v1/rider/orders';
  // static const String orderDetail = '${baseURL}api/v1/rider/orders/';

  // // append orderId
  // static const String acceptOrder = '${baseURL}api/v1/rider/orders/accept';
  // static const String rejectOrder = '${baseURL}api/v1/rider/orders/reject';
  // static const String updateOrderStatus =
  //     '${baseURL}api/v1/rider/orders/update-status';
  // static const String orderHistory = '${baseURL}api/v1/rider/orders/history';

  // // Earnings
  // static const String earnings = '${baseURL}api/v1/rider/earnings';
  // static const String earningsSummary =
  //     '${baseURL}api/v1/rider/earnings/summary';

  // // Location / Tracking
  // static const String updateLocation = '${baseURL}api/v1/rider/location/update';
  // static const String trackOrder =
  //     '${baseURL}api/v1/rider/location/track'; // append orderId
}
