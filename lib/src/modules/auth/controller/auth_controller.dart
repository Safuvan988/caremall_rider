import 'package:care_mall_rider/src/core/services/storage_service.dart';
import 'package:care_mall_rider/src/modules/auth/controller/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// Authentication Controller using GetX for state management
/// Handles all authentication-related business logic
class AuthController extends GetxController {
  // Observable states
  final isLoading = false.obs;
  final isResendingOtp = false.obs;

  // User data
  final phoneNumber = ''.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Restore authentication state from persistent storage on startup
    _restoreAuthState();
  }

  /// Restore authentication state from SharedPreferences
  Future<void> _restoreAuthState() async {
    final savedToken = await StorageService.getAuthToken();
    final savedPhone = await StorageService.getPhoneNumber();
    final savedName = await StorageService.getUserName();
    final savedEmail = await StorageService.getUserEmail();

    if (savedToken != null) authToken.value = savedToken;
    if (savedPhone != null) phoneNumber.value = savedPhone;
    if (savedName != null) userName.value = savedName;
    if (savedEmail != null) userEmail.value = savedEmail;
  }

  /// Sends OTP for login
  ///
  /// Parameters:
  /// - [phone]: 10-digit phone number
  /// - [onSuccess]: Callback function when OTP is sent successfully
  /// - [onError]: Callback function when there's an error
  Future<void> sendLoginOtp({
    required String phone,
    Function? onSuccess,
    Function(String)? onError,
  }) async {
    isLoading.value = true;

    try {
      final result = await AuthRepo.sendOtp(phone: phone, mode: 'login');

      if (result['success']) {
        phoneNumber.value = phone;
        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onSuccess != null) onSuccess();
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onError != null) onError(result['message']);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (onError != null) onError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Sends OTP for signup/registration
  ///
  /// Parameters:
  /// - [phone]: 10-digit phone number
  /// - [name]: User's full name
  /// - [email]: User's email address
  /// - [onSuccess]: Callback function when OTP is sent successfully
  /// - [onError]: Callback function when there's an error
  Future<void> sendSignupOtp({
    required String phone,
    required String name,
    required String email,
    Function? onSuccess,
    Function(String)? onError,
  }) async {
    isLoading.value = true;

    try {
      final result = await AuthRepo.sendOtp(
        phone: phone,
        mode: 'signup',
        name: name,
        email: email,
      );

      if (result['success']) {
        phoneNumber.value = phone;
        userName.value = name;
        userEmail.value = email;
        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onSuccess != null) onSuccess();
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onError != null) onError(result['message']);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (onError != null) onError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies the OTP entered by user
  ///
  /// Parameters:
  /// - [phone]: 10-digit phone number
  /// - [otp]: 6-digit OTP code
  /// - [onSuccess]: Callback function when OTP is verified successfully
  /// - [onError]: Callback function when there's an error
  Future<void> verifyOtp({
    required String phone,
    required String otp,
    Function? onSuccess,
    Function(String)? onError,
  }) async {
    isLoading.value = true;

    try {
      final result = await AuthRepo.verifyOtp(phone: phone, otp: otp);

      if (result['success']) {
        // Save authentication token if provided
        if (result['token'] != null) {
          authToken.value = result['token'];
          // Save token to persistent storage
          await StorageService.saveAuthToken(result['token']);
          await StorageService.savePhoneNumber(phone);
        }

        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onSuccess != null) onSuccess();
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onError != null) onError(result['message']);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify OTP: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (onError != null) onError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Resends OTP using stored user data
  ///
  /// Parameters:
  /// - [mode]: "login" or "signup"
  /// - [onSuccess]: Callback function when OTP is sent successfully
  /// - [onError]: Callback function when there's an error
  Future<void> resendOtp({
    required String mode,
    Function? onSuccess,
    Function(String)? onError,
  }) async {
    isResendingOtp.value = true;

    try {
      final result = await AuthRepo.sendOtp(
        phone: phoneNumber.value,
        mode: mode,
        name: mode == 'signup' ? userName.value : '',
        email: mode == 'signup' ? userEmail.value : '',
      );

      if (result['success']) {
        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onSuccess != null) onSuccess();
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (onError != null) onError(result['message']);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend OTP: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (onError != null) onError(e.toString());
    } finally {
      isResendingOtp.value = false;
    }
  }

  /// Clears all authentication data
  Future<void> logout() async {
    phoneNumber.value = '';
    userName.value = '';
    userEmail.value = '';
    authToken.value = '';
    isLoading.value = false;
    isResendingOtp.value = false;
    // Clear persistent storage
    await StorageService.clearAuthData();
  }

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }
}
