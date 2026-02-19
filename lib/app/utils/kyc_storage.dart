import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KycStorage {
  static const String _drivingLicenseKey = 'kyc_driving_license';
  static const String _identityCardKey = 'kyc_identity_card';
  static const String _addressProofKey = 'kyc_address_proof';
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

  static Future<void> saveIdentityCard({
    required String aadhaarPanNumber,
    required String nameOnCard,
    String? frontImagePath,
    String? backImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'aadhaarPanNumber': aadhaarPanNumber,
      'nameOnCard': nameOnCard,
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
    };
    await prefs.setString(_identityCardKey, jsonEncode(data));
  }

  static Future<void> saveAddressProof({
    required String addressLine1,
    required String city,
    required String state,
    required String pincode,
    String? frontImagePath,
    String? backImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'addressLine1': addressLine1,
      'city': city,
      'state': state,
      'pincode': pincode,
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
    };
    await prefs.setString(_addressProofKey, jsonEncode(data));
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

  static Future<Map<String, dynamic>?> getIdentityCard() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_identityCardKey);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<Map<String, dynamic>?> getAddressProof() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_addressProofKey);
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
    await prefs.remove(_identityCardKey);
    await prefs.remove(_addressProofKey);
    await prefs.remove(_vehicleSelectionKey);
  }
}
