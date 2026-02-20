import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/order_details_screen.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/route_screen.dart';
import 'package:care_mall_rider/src/modules/profile/view/profile_screen.dart';
import 'package:care_mall_rider/src/core/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isOnline = true;
  // 0: New, 1: In Transit, 2: History
  int _selectedTab = 0;
  String _userName = 'Rider';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await StorageService.getUserName();
    if (name != null && name.isNotEmpty) {
      if (mounted) {
        setState(() {
          _userName = name;
        });
      }
    }
  }

  final List<Map<String, dynamic>> _newOrders = [
    {
      'id': '#ORD123452346',
      'distance': '2.5 KM',
      'time': '11:00 AM - 1:00 PM',
      'address': 'John Doe, ABC Building DEF Street, Ernakulam, 682035',
      'amount': '₹ 1,000',
      'isPrePaid': false,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD987654321',
      'distance': '3.0 KM',
      'time': '12:00 PM - 2:00 PM',
      'address': 'Alice Smith, 456 Park Ave, Cochin, 682001',
      'amount': '₹ 550',
      'isPrePaid': true,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD456789123',
      'distance': '4.2 KM',
      'time': '12:30 PM - 2:30 PM',
      'address': 'Bob Johnson, 789 Bay St, Ernakulam, 682036',
      'amount': '₹ 1,200',
      'isPrePaid': false,
      'buttonText': 'View Details',
    },
  ];

  final List<Map<String, dynamic>> _inTransitOrders = [
    {
      'id': '#ORD123456455',
      'distance': '15 KM',
      'time': '11:00 AM - 1:00 PM',
      'address': 'Sarah James, XYZ Mall GHI Road, Cochin, 682016',
      'amount': '',
      'isPrePaid': true,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD123456455',
      'distance': '15 KM',
      'time': '1:30 PM - 3:30 PM',
      'address': 'John Doe, XYZ Mall GHI Road, Cochin, 682016',
      'amount': '',
      'isPrePaid': true,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD123456433',
      'distance': '15 KM',
      'time': '4:00 PM - 6:00 PM',
      'address': 'Emily Clark, 123 Main St, Kottayam, 686001',
      'amount': '',
      'isPrePaid': true,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD852963741',
      'distance': '8 KM',
      'time': '5:00 PM - 7:00 PM',
      'address': 'Michael Brown, 321 Oak Ln, Cochin, 682020',
      'amount': '₹ 800',
      'isPrePaid': false,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD159753456',
      'distance': '12 KM',
      'time': '6:00 PM - 8:00 PM',
      'address': 'Linda Davis, 654 Pine Rd, Ernakulam, 682030',
      'amount': '',
      'isPrePaid': true,
      'buttonText': 'View Details',
    },
  ];

  final List<Map<String, dynamic>> _historyOrders = [
    {
      'id': '#ORD111222333',
      'distance': '5 KM',
      'time': 'Yesterday',
      'address': 'George Wilson, 987 Cedar Blvd, Cochin, 682025',
      'amount': '₹ 450',
      'isPrePaid': true,
      'buttonText': 'View Details',
    },
    {
      'id': '#ORD444555666',
      'distance': '10 KM',
      'time': 'Yesterday',
      'address': 'Nancy Martin, 123 Elm St, Ernakulam, 682031',
      'amount': '₹ 900',
      'isPrePaid': false,
      'buttonText': 'View Details',
    },
    // Add more mock history if needed to match "12" but 2 is enough for demo
  ];

  List<Map<String, dynamic>> get _currentOrders {
    switch (_selectedTab) {
      case 0:
        return _newOrders;
      case 1:
        return _inTransitOrders;
      case 2:
        return _historyOrders;
      default:
        return _newOrders;
    }
  }

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
                      vertical: 16.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(
                            text: 'Hello, $_userName',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textnaturalcolor,
                          ),
                        ),
                        // Online/Offline Toggle
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _isOnline,
                                  onChanged: (val) =>
                                      setState(() => _isOnline = val),
                                  activeColor: AppColors.primarycolor,
                                  activeTrackColor: AppColors.primarycolor
                                      .withValues(alpha: 0.2),
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey[200],
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              AppText(
                                text: _isOnline ? 'Online' : 'Offline',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: _isOnline
                                    ? AppColors.textnaturalcolor
                                    : Colors.grey,
                              ),
                              SizedBox(width: 8.w),
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
                      height: 45.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          _buildTab('New (${_newOrders.length})', 0),
                          _buildTab(
                            'In Transit (${_inTransitOrders.length})',
                            1,
                          ),
                          _buildTab(
                            'History (12)',
                            2,
                          ), // Keep history fixed for now or update
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ─── Order List ──────────────────────────────────────────────────
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _currentOrders.length,
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final order = _currentOrders[index];
                          return _buildOrderCard(order);
                        },
                      ),
                    ),
                  ] else if (_selectedIndex == 1) ...[
                    const Expanded(child: RouteScreen()),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: ID and Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Order ID : ${order['id']}',
                  fontSize: 15.sp,
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultSecondarycolor,
            ),
            SizedBox(height: 8.h),

            Divider(height: 1.h, thickness: 1, color: Colors.grey[200]),
            SizedBox(height: 8.h),

            // Address
            AppText(
              text: order['address'],
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultSecondarycolor,
              maxLines: 2,
            ),
            SizedBox(height: 16.h),

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
                      SizedBox(height: 2.h),
                      AppText(
                        text: order['amount'],
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textnaturalcolor,
                      ),
                    ] else
                      AppText(
                        text: 'Pre Paid',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPositiveSecondarycolor, // Green
                      ),
                  ],
                ),
                SizedBox(width: 16.w), // Spacer
                Expanded(
                  child: SizedBox(
                    height: 40.h,
                    child: AppButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                      btncolor: AppColors.primarycolor,
                      borderRadius: 6.r,
                      buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          AppColors.primarycolor,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                      child: AppText(
                        text: order['buttonText'] ?? 'View Details',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
