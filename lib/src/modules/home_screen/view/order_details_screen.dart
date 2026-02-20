import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _paymentCollected = false;

  @override
  Widget build(BuildContext context) {
    // Determine if it is PrePaid or COD based on the order data
    final bool isPrePaid = widget.order['isPrePaid'] ?? false;
    // For demo purposes, let's assume if it's PrePaid, there might be special instructions
    // In a real app, this would come from the API/order object.
    // Let's verify 'buttonText' from HomeScreen data to mock this behavior if needed,
    // or just assume PrePaid orders have instructions for this task.
    final String? specialInstructions = isPrePaid
        ? "Leave the package at the door if no one answers. call before arrival"
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF5F5F5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: AppText(
          text: 'Order Details',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textnaturalcolor,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID Header
                  AppText(
                    text: 'Order ID : ${widget.order['id']}',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textnaturalcolor,
                  ),
                  SizedBox(height: 24.h),

                  // Customer Details Card
                  _buildCustomerDetailsCard(),
                  SizedBox(height: 16.h),

                  // Payment Details Card
                  _buildPaymentDetailsCard(isPrePaid),
                  SizedBox(height: 16.h),

                  // Special Instructions (Only if PrePaid/Exists)
                  if (specialInstructions != null) ...[
                    _buildSpecialInstructionsCard(specialInstructions),
                    SizedBox(height: 16.h),
                  ],

                  // Package Details Card
                  _buildPackageDetailsCard(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
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
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      // Handle Cannot Deliver
                    },
                    btncolor: Colors.white,
                    borderRadius: 8.r,
                    buttonStyle: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(
                        const BorderSide(color: AppColors.errorMain),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      elevation: WidgetStateProperty.all(0),
                    ),
                    child: AppText(
                      text: 'Cannot Deliver',
                      color: AppColors.errorMain,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      // Handle Delivery OTP
                    },
                    btncolor: AppColors.primarycolor,
                    borderRadius: 8.r,
                    child: AppText(
                      text: 'Delivery OTP',
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: child,
    );
  }

  Widget _buildCustomerDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Customer Details',
            fontSize: 12.sp,
            color: Colors.grey[500]!,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: 'Sarah James', // Mock name match screenshot
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textnaturalcolor,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: 'XYZ Mall GHI Road, Cochin, 682016',
            fontSize: 13.sp,
            color: Colors.grey[600]!,
            maxLines: 2,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildOutlineButton(
                  icon: Icons.location_on_outlined,
                  label: 'View on Maps',
                  onTap: () {},
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOutlineButton(
                  icon: Icons.phone_outlined,
                  label: 'Call Customer',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard(bool isPrePaid) {
    return _buildCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Payment Details',
                    fontSize: 12.sp,
                    color: Colors.grey[500]!,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: 'Payment Method',
                    fontSize: 14.sp,
                    color: AppColors.textnaturalcolor,
                  ),
                ],
              ),
              if (isPrePaid)
                AppText(
                  text: 'Pre Paid',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPositiveSecondarycolor,
                )
              else
                AppText(
                  text: 'Cash on Delivery',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textnaturalcolor,
                ),
            ],
          ),
          if (!isPrePaid) ...[
            SizedBox(height: 12.h),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Amount To Collect',
                  fontSize: 14.sp,
                  color: Colors.grey[600]!,
                ),
                AppText(
                  text: widget.order['amount'] ?? '₹ 0',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors
                      .ratingYellowcolor, // Matches gold color in screenshot
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Payment Collected',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textnaturalcolor,
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _paymentCollected,
                    onChanged: (val) => setState(() => _paymentCollected = val),
                    thumbColor: const WidgetStatePropertyAll(Colors.white),
                    trackColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.red;
                      }
                      return Colors.grey[300];
                    }),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecialInstructionsCard(String instructions) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EE), // Light yellow bg from screenshot
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFDFA6)), // Gold border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16.sp,
                color: const Color(0xFFA67118), // Brown/Gold text
              ),
              SizedBox(width: 8.w),
              AppText(
                text: 'Special Instructions',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA67118),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          AppText(
            text: instructions,
            fontSize: 13.sp,
            color: const Color(0xFFA67118),
            maxLines: 3,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Package Details',
            fontSize: 12.sp,
            color: Colors.grey[500]!,
          ),
          SizedBox(height: 12.h),
          _buildPackageItem('Noise colorfit pro 4', '1'),
          Divider(color: Colors.grey[200], height: 24.h),
          _buildPackageItem('Silicon case for iPhone 16', '1'),
        ],
      ),
    );
  }

  Widget _buildPackageItem(String name, String qty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: name,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textnaturalcolor,
        ),
        SizedBox(height: 4.h),
        AppText(text: 'Qty:$qty', fontSize: 13.sp, color: Colors.grey[500]!),
      ],
    );
  }

  Widget _buildOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Colors.red), // Red border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: Colors.grey[600],
            ), // Grey icon as per screenshot
            SizedBox(width: 8.w),
            AppText(
              text: label,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textnaturalcolor,
            ),
          ],
        ),
      ),
    );
  }
}
