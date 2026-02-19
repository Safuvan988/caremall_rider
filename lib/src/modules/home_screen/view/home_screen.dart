import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:care_mall_rider/src/modules/profile/view/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isOnline = true;
  int _selectedTab = 0; // 0: New, 1: In Transit, 2: History

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD123456885',
      'distance': '5 KM',
      'time': '11:00 AM - 1:00 PM',
      'address': 'John Doe, ABC Building DEF Street, Ernakulam, 682035',
      'amount': '₹ 1,000',
      'isPrePaid': false,
    },
    {
      'id': '#ORD123456455',
      'distance': '15 KM',
      'time': '11:00 AM - 1:00 PM',
      'address': 'Sarah James, ABC Building DEF Street, Ernakulam, 682035',
      'amount': '',
      'isPrePaid': true,
    },
    {
      'id': '#ORD123456455',
      'distance': '15 KM',
      'time': '11:00 AM - 1:00 PM',
      'address': 'Sarah James, ABC Building DEF Street, Ernakulam, 682035',
      'amount': '',
      'isPrePaid': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: _selectedIndex == 2
          ? const ProfileScreen()
          : SafeArea(
              child: Column(
                children: [
                  // ─── Header ──────────────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        // Using App Logo as avatar placeholder for now, or user icon
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 20.r,
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Hello, James Cameron',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textnaturalcolor,
                              ),
                            ],
                          ),
                        ),
                        // Online/Offline Toggle
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  value: _isOnline,
                                  onChanged: (val) =>
                                      setState(() => _isOnline = val),
                                  activeThumbColor: Colors.red,
                                  activeTrackColor: Colors.red.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              AppText(
                                text: _isOnline ? 'Online' : 'Offline',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textnaturalcolor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_selectedIndex == 0) ...[
                    // ─── Search Bar ──────────────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Order ID',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ─── Tabs ────────────────────────────────────────────────────────
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          _buildTab('New (3)', 0),
                          _buildTab('In Transit (5)', 1),
                          _buildTab('History (12)', 2),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ─── Order List ──────────────────────────────────────────────────
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _orders.length,
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return _buildOrderCard(order);
                        },
                      ),
                    ),
                  ] else if (_selectedIndex == 1) ...[
                    const Expanded(
                      child: Center(
                        child: AppText(text: 'Route screen coming soon!'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

      // ─── Bottom Navigation ─────────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primarycolor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ─── Helper Widgets ──────────────────────────────────────────────────────

  Widget _buildTab(String title, int index) {
    final bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AppText(
              text: title,
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primarycolor : Colors.grey[600]!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final bool isPrePaid = order['isPrePaid'];

    // Blue dashed border for active-looking card (example logic: second item)
    // For now, standard border.
    // If you want specific dashed border for "Selected" item logic, we can add it.
    // The screenshot showed a blue dashed border around one item.
    // We'll stick to standard white card for now to keep it clean.

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: ID and Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Order ID : ${order['id']}',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textnaturalcolor,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE3E3), // Light red bg
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: Colors.red,
                      ),
                      SizedBox(width: 4.w),
                      AppText(
                        text: order['distance'],
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textnaturalcolor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Time
            AppText(
              text: order['time'],
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultSecondarycolor,
            ),
            SizedBox(height: 8.h),

            // Address
            AppText(
              text: order['address'],
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultSecondarycolor,
              maxLines: 2,
            ),
            Divider(height: 24.h, color: Colors.grey[200]),

            // Bottom Row: Payment and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isPrePaid) ...[
                      AppText(
                        text: 'Cash on Delivery',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDefaultSecondarycolor,
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        text: order['amount'],
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textnaturalcolor,
                      ),
                    ] else
                      AppText(
                        text: 'Pre Paid',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green, // Or primary color
                      ),
                  ],
                ),
                Expanded(
                  // Button needs to be flexible? No, fixed width or expanded?
                  // Use Expanded spacer then button
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 140.w,
                        height: 40.h,
                        child: AppButton(
                          onPressed: () {},
                          child: AppText(
                            text: 'Start Delivery',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
