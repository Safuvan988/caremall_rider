import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KycStorage {
  static const String _drivingLicenseKey = 'kyc_driving_license';
  static const String _bankDetailsKey = 'kyc_bank_details';

  static const String _vehicleSelectionKey = 'kyc_vehicle_selection';

  static Future<void> saveDrivingLicense({
    required String licenseNumber,
    required String dob,
    required String expiryDate,
    String? frontImagePath,
    String? backImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'licenseNumber': licenseNumber,
      'dob': dob,
      'expiryDate': expiryDate,
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
    };
    await prefs.setString(_drivingLicenseKey, jsonEncode(data));
  }

  static Future<void> saveBankDetails({
    required String paymentMode,
    String accountHolderName = '',
    String accountNumber = '',
    String ifscCode = '',
    String bankName = '',
    String upiId = '',
    String upiNumber = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'paymentMode': paymentMode,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'upiId': upiId,
      'upiNumber': upiNumber,
    };
    await prefs.setString(_bankDetailsKey, jsonEncode(data));
  }

  static Future<void> saveVehicleSelection({
    required int vehicleIndex,
    required String vehicleTitle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {'vehicleIndex': vehicleIndex, 'vehicleTitle': vehicleTitle};
    await prefs.setString(_vehicleSelectionKey, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getDrivingLicense() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_drivingLicenseKey);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<Map<String, dynamic>?> getBankDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_bankDetailsKey);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<Map<String, dynamic>?> getVehicleSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_vehicleSelectionKey);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_drivingLicenseKey);
    await prefs.remove(_bankDetailsKey);

    await prefs.remove(_vehicleSelectionKey);
  }
}
