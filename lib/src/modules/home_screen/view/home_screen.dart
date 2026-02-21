import 'package:care_mall_rider/app/app_buttons/app_buttons.dart';
import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/order_details_screen.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/route_screen.dart';
import 'package:care_mall_rider/src/modules/profile/view/profile_screen.dart';
import 'package:care_mall_rider/src/core/services/storage_service.dart';
import 'package:care_mall_rider/src/modules/home_screen/controller/order_repo.dart';
import 'package:care_mall_rider/src/modules/home_screen/model/delivery_order_model.dart';
import 'package:care_mall_rider/src/modules/home_screen/model/return_order_model.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/return_details_screen.dart';
import 'package:care_mall_rider/src/modules/wallet/view/wallet_screen.dart';

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

  // ── API state ────────────────────────────────────────────────────────────
  List<DeliveryOrder> _allOrders = [];
  bool _ordersLoading = true;
  String? _ordersError;

  List<ReturnOrder> _returnOrders = [];
  bool _returnsLoading = true;
  String? _returnsError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchOrders();
  }

  Future<void> _loadUserData() async {
    final name = await StorageService.getUserName();
    if (name != null && name.isNotEmpty && mounted) {
      setState(() => _userName = name);
    }
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _ordersLoading = true;
      _ordersError = null;
      _returnsLoading = true;
      _returnsError = null;
    });
    // Fetch delivery orders and return orders in parallel
    await Future.wait([
      OrderRepo.getDeliveryOrders()
          .then((orders) {
            if (mounted) setState(() => _allOrders = orders);
          })
          .catchError((e) {
            if (mounted) setState(() => _ordersError = e.toString());
          }),
      OrderRepo.getReturnOrders()
          .then((returns) {
            if (mounted) setState(() => _returnOrders = returns);
          })
          .catchError((e) {
            if (mounted) setState(() => _returnsError = e.toString());
          }),
    ]);
    if (mounted) {
      setState(() {
        _ordersLoading = false;
        _returnsLoading = false;
      });
    }
  }

  // Tab filters based on orderStatus
  static const _newStatuses = {
    'pending',
    'confirmed',
    'processing',
    'dispatched',
  };
  static const _transitStatuses = {'shipped', 'out_for_delivery'};
  static const _historyStatuses = {'delivered', 'cancelled', 'failed'};

  List<DeliveryOrder> get _newOrders =>
      _allOrders.where((o) => _newStatuses.contains(o.orderStatus)).toList();
  List<DeliveryOrder> get _inTransitOrders => _allOrders
      .where((o) => _transitStatuses.contains(o.orderStatus))
      .toList();
  List<DeliveryOrder> get _historyOrders => _allOrders
      .where((o) => _historyStatuses.contains(o.orderStatus))
      .toList();

  // _selectedTab: 0=New 1=InTransit 2=Return 3=History
  bool get _isReturnTab => _selectedTab == 2;

  List<DeliveryOrder> get _currentOrders {
    switch (_selectedTab) {
      case 0:
        return _newOrders;
      case 1:
        return _inTransitOrders;
      case 3:
        return _historyOrders;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: _selectedIndex == 3
          ? const ProfileScreen()
          : _selectedIndex == 2
          ? const WalletScreen()
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
                                  activeThumbColor: AppColors.primarycolor,
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

                    // ─── Tabs ────────────────────────────────────────────────────────────────
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
                          _buildTab('Returns (${_returnOrders.length})', 2),
                          _buildTab('History (${_historyOrders.length})', 3),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ─── Order / Return List ──────────────────────────────────────────
                    Expanded(
                      child: _isReturnTab
                          ? _buildReturnList()
                          : _buildDeliveryList(),
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
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
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

  Widget _buildDeliveryList() {
    if (_ordersLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_ordersError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            AppText(
              text: 'Could not load orders',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]!,
            ),
            SizedBox(height: 8.h),
            TextButton.icon(
              onPressed: _fetchOrders,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    final orders = _currentOrders;
    if (orders.isEmpty) {
      return Center(
        child: AppText(
          text: 'No orders here',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey[500]!,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: orders.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildReturnList() {
    if (_returnsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_returnsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            AppText(
              text: 'Could not load returns',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]!,
            ),
            SizedBox(height: 8.h),
            TextButton.icon(
              onPressed: _fetchOrders,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_returnOrders.isEmpty) {
      return Center(
        child: AppText(
          text: 'No return orders',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey[500]!,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: _returnOrders.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _buildReturnCard(_returnOrders[index]),
      ),
    );
  }

  Widget _buildReturnCard(ReturnOrder ret) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReturnDetailsScreen(returnOrder: ret),
          ),
        );
      },
      child: Container(
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
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      text: 'Return #${ret.returnId}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textnaturalcolor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: AppText(
                      text: ret.orderStatus.replaceAll('_', ' ').toUpperCase(),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                ],
              ),
              if (ret.customerName != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14.sp,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: AppText(
                        text: ret.customerName!,
                        fontSize: 13.sp,
                        color: AppColors.textnaturalcolor,
                      ),
                    ),
                  ],
                ),
              ],
              if (ret.address != null) ...[
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.sp,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: AppText(
                        text: ret.address!,
                        fontSize: 12.sp,
                        color: Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ],
              if (ret.reason != null) ...[
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14.sp,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: AppText(
                        text: 'Reason: ${ret.reason}',
                        fontSize: 12.sp,
                        color: Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: '₹ ${ret.totalAmount.toStringAsFixed(0)}',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textnaturalcolor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(DeliveryOrder order) {
    final bool isCod = order.isCod;

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
            // Top Row: Order ID + Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    text: 'Order ID : ${order.orderId}',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textnaturalcolor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _statusBadgeBg(order.orderStatus),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: AppText(
                    text: order.orderStatus.replaceAll('_', ' ').toUpperCase(),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: _statusBadgeFg(order.orderStatus),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Destination
            if (order.dispatch?.destination != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14.sp,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: AppText(
                      text: order.dispatch!.destination,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDefaultSecondarycolor,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],

            Divider(height: 1.h, thickness: 1, color: Colors.grey[200]),
            SizedBox(height: 8.h),

            // Delivery address
            AppText(
              text: order.fullAddress,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultSecondarycolor,
              maxLines: 2,
            ),
            SizedBox(height: 16.h),

            // Bottom Row: Payment + Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCod) ...[
                      AppText(
                        text: 'Cash on Delivery',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDefaultSecondarycolor,
                      ),
                      SizedBox(height: 2.h),
                      AppText(
                        text: '₹ ${order.totalAmount.toStringAsFixed(0)}',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textnaturalcolor,
                      ),
                    ] else
                      AppText(
                        text: 'Pre Paid',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPositiveSecondarycolor,
                      ),
                  ],
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: order.orderStatus.toLowerCase() == 'delivered'
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsScreen(order: order),
                              ),
                            );
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EE),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: const Color(0xFF1E7E4C),
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                AppText(
                                  text: 'Paid',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E7E4C),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
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
                              text: _selectedTab == 0
                                  ? 'Start Delivery'
                                  : 'View Details',
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

  Color _statusBadgeBg(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFFE6F4EE);
      case 'cancelled':
      case 'failed':
        return const Color(0xFFFFE3E3);
      case 'shipped':
      case 'out_for_delivery':
        return const Color(0xFFE8F0FE);
      case 'dispatched':
        return const Color(0xFFFFF3E0);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _statusBadgeFg(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF1E7E4C);
      case 'cancelled':
      case 'failed':
        return Colors.red;
      case 'shipped':
      case 'out_for_delivery':
        return const Color(0xFF1A56DB);
      case 'dispatched':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF374151);
    }
  }
}
