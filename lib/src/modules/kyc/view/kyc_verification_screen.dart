import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:care_mall_rider/src/modules/kyc/view/driving_license_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ─── Red Header ───────────────────────────────────────────────
          _KycHeader(),

          // ─── Body ─────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "WHAT YOU'LL NEED",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDefaultSecondarycolor,
                    letterspace: 0.8,
                  ),
                  const SizedBox(height: 12),

                  // KYC Step Cards
                  _KycStepCard(
                    icon: Icons.badge_outlined,
                    iconBgColor: const Color(0xFFE8F0FE),
                    iconColor: const Color(0xFF4A6CF7),
                    title: 'Driving License',
                    subtitle: 'Upload front & back of your license',
                  ),
                  const SizedBox(height: 10),

                  _KycStepCard(
                    icon: Icons.account_balance_outlined,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF2E7D32),
                    title: 'Bank / UPI Details',
                    subtitle: 'Add your payout bank or UPI account',
                  ),
                  const SizedBox(height: 10),

                  _KycStepCard(
                    icon: Icons.directions_car_outlined,
                    iconBgColor: const Color(0xFFFFF8E1),
                    iconColor: const Color(0xFFFFA621),
                    title: 'Vehicle Selection',
                    subtitle: 'Choose the vehicle type for deliveries',
                  ),

                  const SizedBox(height: 32),

                  // ─── Start KYC Button ──────────────────────────────
                  AppButton(
                    borderRadius: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DrivingLicenseScreen(),
                        ),
                      );
                    },
                    child: AppText(
                      text: 'Start KYC Verification',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whitecolor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Red Header Widget ─────────────────────────────────────────────────────────
class _KycHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primarycolor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          child: Column(
            children: [
              // Shield icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),

              AppText(
                text: 'KYC Verification',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.whitecolor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              AppText(
                text: 'Complete your KYC to start delivering and earning',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── KYC Step Card ─────────────────────────────────────────────────────────────
class _KycStepCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _KycStepCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textnaturalcolor,
                  ),
                  const SizedBox(height: 3),
                  AppText(
                    text: subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDefaultSecondarycolor,
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}
