import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:care_mall_rider/app/utils/spaces.dart';
import 'package:care_mall_rider/app/utils/kyc_storage.dart';
import 'package:care_mall_rider/src/modules/kyc/view/vehicle_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Payment mode: 'bank' or 'upi'
  String _paymentMode = 'bank';

  // Bank controllers
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _bankNameController = TextEditingController();

  // UPI controllers
  final _upiNumberController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _upiNumberController.dispose();
    super.dispose();
  }

  void _saveAndContinue() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await KycStorage.saveBankDetails(
        paymentMode: _paymentMode,
        accountHolderName: _accountHolderController.text,
        accountNumber: _accountNumberController.text,
        ifscCode: _ifscController.text,
        bankName: _bankNameController.text,
        upiId: '',
        upiNumber: _upiNumberController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VehicleSelectionScreen()),
      );
    }
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
          text: 'Bank Details',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textnaturalcolor,
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          children: [
            // ── Step Progress ──────────────────────────────────────────
            _StepProgressBar(currentStep: 2, totalSteps: 3),
            SizedBox(height: 22.h),

            // ── Section Title ──────────────────────────────────────────
            AppText(
              text: 'Payment Details',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textnaturalcolor,
            ),
            SizedBox(height: 4.h),
            AppText(
              text: 'Add your bank or UPI details for payouts',
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultSecondarycolor,
            ),
            SizedBox(height: 24.h),

            // ── Payment Mode Toggle ────────────────────────────────────
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  _ModeTab(
                    label: 'Bank Transfer',
                    isSelected: _paymentMode == 'bank',
                    onTap: () => setState(() => _paymentMode = 'bank'),
                  ),
                  _ModeTab(
                    label: 'UPI',
                    isSelected: _paymentMode == 'upi',
                    onTap: () => setState(() => _paymentMode = 'upi'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // ── Bank Fields ────────────────────────────────────────────
            if (_paymentMode == 'bank') ...[
              AppText(
                text: 'Account Holder Name',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textnaturalcolor,
              ),
              defaultSpacerSmall,
              _InputField(
                controller: _accountHolderController,
                hint: 'Enter full name',
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 16.h),

              AppText(
                text: 'Account Number',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textnaturalcolor,
              ),
              defaultSpacerSmall,
              _InputField(
                controller: _accountNumberController,
                hint: 'Enter account number',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.length < 6)
                    ? 'Invalid account number'
                    : null,
              ),
              SizedBox(height: 16.h),

              AppText(
                text: 'IFSC Code',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textnaturalcolor,
              ),
              defaultSpacerSmall,
              _InputField(
                controller: _ifscController,
                hint: 'e.g. SBIN0001234',
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  _UpperCaseFormatter(),
                ],
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 16.h),

              AppText(
                text: 'Bank Name',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textnaturalcolor,
              ),
              defaultSpacerSmall,
              _InputField(
                controller: _bankNameController,
                hint: 'e.g. State Bank of India',
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ],

            // ── UPI Fields ─────────────────────────────────────────────
            if (_paymentMode == 'upi') ...[
              AppText(
                text: 'UPI Registered Mobile Number',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textnaturalcolor,
              ),
              defaultSpacerSmall,
              _InputField(
                controller: _upiNumberController,
                hint: 'Enter mobile number',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) => (v == null || v.length < 10)
                    ? 'Enter valid mobile number'
                    : null,
              ),
            ],

            SizedBox(height: 24.h),

            // ── Info Card ──────────────────────────────────────────────
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4FF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFBFD4FF), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔒', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AppText(
                      text:
                          'Your payment details are encrypted and stored securely. They will only be used for delivery payouts.',
                      fontSize: 12.sp,
                      color: AppColors.textDefaultSecondarycolor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // ── Save & Continue ────────────────────────────────────────
            AppButton(
              isLoading: _isLoading,
              borderRadius: 30.r,
              onPressed: () {
                HapticFeedback.selectionClick();
                _saveAndContinue();
              },
              child: AppText(
                text: 'Save & Continue',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whitecolor,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

// ─── Payment Mode Tab ──────────────────────────────────────────────────────────
class _ModeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AppText(
              text: label,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? AppColors.primarycolor
                  : AppColors.textDefaultSecondarycolor,
            ),
          ),
        ),
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
      final bool isCompleted = index < currentStep - 1;
      children.add(
        Container(
          width: 28.w,
          height: 28.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primarycolor : const Color(0xFFE0E0E0),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                : AppText(
                    text: '${index + 1}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? Colors.white
                        : AppColors.textDefaultSecondarycolor,
                  ),
          ),
        ),
      );
      if (index < totalSteps - 1) {
        children.add(
          Expanded(
            child: Container(
              height: 2.h,
              color: isActive
                  ? AppColors.primarycolor.withValues(alpha: 0.3)
                  : const Color(0xFFE0E0E0),
            ),
          ),
        );
      }
    }
    return Row(children: children);
  }
}

// ─── Reusable Input Field ──────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textDefaultTertiarycolor,
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.primarycolor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

// ─── Upper Case Formatter ──────────────────────────────────────────────────────
class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
