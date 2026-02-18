import 'dart:convert';
import 'package:http/http.dart' as http;

/// Repository class for authentication-related API calls
/// Follows the repository pattern to separate data layer from business logic
class AuthRepo {
  /// Sends OTP to the provided phone number
  ///
  /// Parameters:
  /// - [phone]: 10-digit phone number
  /// - [mode]: "login" or "signup"
  /// - [name]: User's full name (optional for login, required for signup)
  /// - [email]: User's email (optional for login, required for signup)
  ///
  /// Returns a Map with API response data
  static Future<Map<String, dynamic>> sendOtp({
    required String phone,
    required String mode,
    String name = '',
    String email = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(''), // TODO: add sendOtp URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'mode': mode,
          'name': name,
          'email': email,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'OTP sent successfully!',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ??
              'Failed to send OTP. Please try again.',
          'data': responseData,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Verifies the OTP entered by the user
  ///
  /// Parameters:
  /// - [phone]: 10-digit phone number
  /// - [otp]: OTP code received
  ///
  /// Returns a Map with API response data
  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(''), // TODO: add verifyOtp URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'OTP verified successfully!',
          'data': responseData,
          'token': responseData['token'], // Save token if provided
          'user': responseData['user'], // Save user data if provided
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Invalid OTP. Please try again.',
          'data': responseData,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
