import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:care_mall_rider/src/core/services/storage_service.dart';
import 'package:care_mall_rider/app/utils/kyc_storage.dart';
import 'package:care_mall_rider/src/modules/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Rider';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await StorageService.getUserName();
    final email = await StorageService.getUserEmail();
    if (mounted) {
      setState(() {
        if (name != null) _name = name;
        if (email != null) _email = email;
      });
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: AppText(
            text: 'Logout',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
          content: AppText(
            text: 'Are you sure you want to logout?',
            fontSize: 14.sp,
            color: AppColors.textDefaultSecondarycolor,
          ),
          actions: <Widget>[
            TextButton(
              child: const AppText(
                text: 'Cancel',
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const AppText(
                text: 'Logout',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Clear all storage via services
    await StorageService.clearAuthData();
    await KycStorage.clearAll();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: AppText(
          text: 'Profile',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textnaturalcolor,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Profile Icon / Placeholder
            CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, size: 50.sp, color: Colors.grey),
            ),
            SizedBox(height: 20.h),
            AppText(text: _name, fontSize: 20.sp, fontWeight: FontWeight.w700),
            if (_email.isNotEmpty) ...[
              SizedBox(height: 10.h),
              AppText(
                text: _email,
                fontSize: 14.sp,
                color: AppColors.textDefaultSecondarycolor,
              ),
            ],
            const Spacer(),
            AppButton(
              onPressed: () => _showLogoutDialog(context),
              btncolor: AppColors.primarycolor,
              child: AppText(
                text: 'Logout',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
