import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:care_mall_rider/app/utils/kyc_storage.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int? _selectedVehicleIndex;
  bool _isLoading = false;

  final List<_VehicleModel> _vehicles = [
    _VehicleModel(
      title: 'Bike',
      description: 'Small parcel ',
      limit: 'Up to 10 kg',
      price: '₹8-15/km',
      icon: Icons.two_wheeler,
      color: const Color(0xFFFFF0F0),
      iconColor: Colors.red,
      limitColor: const Color(0xFFE8F0FE),
      limitTextColor: const Color(0xFF4A6CF7),
      priceColor: const Color(0xFFFFE8E8),
      priceTextColor: Colors.red,
    ),
    _VehicleModel(
      title: 'Car',
      description: 'Medium parcels & goods',
      limit: 'Up to 50 kg',
      price: '₹15-25/km',
      icon: Icons.local_taxi,
      color: const Color(0xFFE8F0FE),
      iconColor: const Color(0xFF4A6CF7),
      limitColor: const Color(0xFFF3E5F5),
      limitTextColor: Colors.purple,
      priceColor: const Color(0xFFFFE8E8),
      priceTextColor: Colors.red,
    ),
    _VehicleModel(
      title: 'Half Lorry',
      description: 'Large packages',
      limit: 'Up to 500 kg',
      price: '₹25-40/km',
      icon: Icons.local_shipping,
      color: const Color(0xFFF3E5F5),
      iconColor: Colors.purple,
      limitColor: const Color(0xFFFFF3E0),
      limitTextColor: Colors.orange,
      priceColor: const Color(0xFFFFE8E8),
      priceTextColor: Colors.red,
    ),
  ];

  void _submitVerification() {
    if (_selectedVehicleIndex == null) return;

    setState(() => _isLoading = true);

    // Save data locally
    if (_selectedVehicleIndex != null) {
      KycStorage.saveVehicleSelection(
        vehicleIndex: _selectedVehicleIndex!,
        vehicleTitle: _vehicles[_selectedVehicleIndex!].title,
      );
    }

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to Dashboard or Success Screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application Submitted for Verification!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: Colors.black,
            ),
          ),
        ),
        title: AppText(
          text: 'Vehicle Selection',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textnaturalcolor,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              children: [
                // ── Step Progress ──────────────────────────────────────────
                const _StepProgressBar(currentStep: 4, totalSteps: 4),
                SizedBox(height: 22.h),

                // ── Section Title ──────────────────────────────────────────
                AppText(
                  text: 'Select Your Vehicle',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textnaturalcolor,
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: 'Choose the vehicle type you\'ll use for deliveries',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDefaultSecondarycolor,
                ),
                SizedBox(height: 20.h),

                // ── Vehicle List ───────────────────────────────────────────
                ...List.generate(_vehicles.length, (index) {
                  final vehicle = _vehicles[index];
                  final isSelected = _selectedVehicleIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _VehicleCard(
                      vehicle: vehicle,
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedVehicleIndex = index);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // ── Bottom Button ──────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: AppButton(
              isLoading: _isLoading,
              borderRadius: 30.r,
              onPressed: _selectedVehicleIndex != null
                  ? _submitVerification
                  : null,
              btncolor: _selectedVehicleIndex != null
                  ? AppColors.primarycolor
                  : Colors.grey[300],
              child: AppText(
                text: 'Submit for Verification',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: _selectedVehicleIndex != null
                    ? AppColors.whitecolor
                    : Colors.grey[600] ?? Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleModel {
  final String title;
  final String description;
  final String limit;
  final String price;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final Color limitColor;
  final Color limitTextColor;
  final Color priceColor;
  final Color priceTextColor;

  _VehicleModel({
    required this.title,
    required this.description,
    required this.limit,
    required this.price,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.limitColor,
    required this.limitTextColor,
    required this.priceColor,
    required this.priceTextColor,
  });
}

class _VehicleCard extends StatelessWidget {
  final _VehicleModel vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primarycolor : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primarycolor.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Vehicle Icon
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: vehicle.color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(vehicle.icon, color: vehicle.iconColor, size: 30.sp),
            ),
            SizedBox(width: 16.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: vehicle.title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textnaturalcolor,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: vehicle.description,
                    fontSize: 12.sp,
                    color: AppColors.textDefaultSecondarycolor,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _Tag(
                        text: vehicle.limit,
                        bgColor: vehicle.limitColor,
                        textColor: vehicle.limitTextColor,
                      ),
                      SizedBox(width: 8.w),
                      _Tag(
                        text: vehicle.price,
                        bgColor: vehicle.priceColor,
                        textColor: vehicle.priceTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _Tag({
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: AppText(
        text: text,
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}

// ─── Step Progress Bar ─────────────────────────────────────────────────────────
class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int index = 0; index < totalSteps; index++) {
      final bool isActive = index < currentStep;
      final bool isCompleted =
          index < currentStep - 1; // Completed steps are checked
      final bool isCurrent = index == currentStep - 1;

      // Circle
      children.add(
        Container(
          width: 28.w,
          height: 28.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCurrent
                ? AppColors.primarycolor
                : const Color(0xFFE0E0E0),
          ),
          child: Center(
            child: isActive
                ? (isCompleted
                      ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                      : AppText(
                          text: '${index + 1}',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ))
                : AppText(
                    text: '${index + 1}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDefaultSecondarycolor,
                  ),
          ),
        ),
      );

      // Line (except after last)
      if (index < totalSteps - 1) {
        children.add(
          Expanded(
            child: Container(
              height: 2.h,
              color: isActive
                  ? AppColors
                        .primarycolor // Active line if previous step is active
                  : const Color(0xFFE0E0E0),
            ),
          ),
        );
      }
    }

    return Row(children: children);
  }
}
