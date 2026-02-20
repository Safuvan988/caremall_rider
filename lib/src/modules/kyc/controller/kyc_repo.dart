import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:care_mall_rider/app/utils/network/apiurls.dart';
import 'package:care_mall_rider/src/core/services/storage_service.dart';

/// Repository for KYC-related API calls
class KycRepo {
  /// Submits the full KYC data as a multipart form-data request.
  ///
  /// Based on the API response structure:
  /// {
  ///   "kyc": { "drivingLicence": "...", "status": "under_review" },
  ///   "vehicleDetails": { "vehicleType": "...", "registrationNumber": "..." },
  ///   "bankDetails": { ... }
  /// }
  static Future<Map<String, dynamic>> submitKyc({
    required String vehicleType,
    required String registrationNumber,
    required String licenseNumber,
    File? drivingLicenceFront,
    String paymentMode = 'bank',
    String accountHolderName = '',
    String accountNumber = '',
    String ifscCode = '',
    String bankName = '',
    String upiId = '',
    String upiNumber = '',
  }) async {
    try {
      // Read token exclusively from StorageService
      String? token = await StorageService.getAuthToken();

      // Debug: print token status
      if (token != null && token.isNotEmpty) {
        final maskedToken = token.length > 10
            ? '${token.substring(0, 5)}...${token.substring(token.length - 5)}'
            : '***';
        // ignore: avoid_print
        print('[KycRepo] Token found: $maskedToken (length: ${token.length})');
      } else {
        // ignore: avoid_print
        print(
          '[KycRepo] WARNING: No token found — request will be Unauthorized',
        );
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrls.kycSubmit),
      );

      // Add auth header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // Vehicle details
      request.fields['vehicleType'] = vehicleType;
      request.fields['registrationNumber'] = registrationNumber;

      // Driving license details
      request.fields['licenseNumber'] = licenseNumber;

      // Bank details
      request.fields['paymentMode'] = paymentMode;
      request.fields['accountHolderName'] = accountHolderName;
      request.fields['accountNumber'] = accountNumber;
      request.fields['ifscCode'] = ifscCode;
      request.fields['bankName'] = bankName;
      request.fields['upiId'] = upiId;
      request.fields['upiNumber'] = upiNumber;

      // Attach driving licence image
      if (drivingLicenceFront != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'drivingLicence',
            drivingLicenceFront.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'KYC submitted successfully!',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ??
              'KYC submission failed. Please try again.',
          'data': responseData,
        };
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
