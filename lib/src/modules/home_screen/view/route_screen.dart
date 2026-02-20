import 'dart:async';

import 'package:care_mall_rider/app/commenwidget/apptext.dart';
import 'package:care_mall_rider/app/theme_data/app_colors.dart';
import 'package:care_mall_rider/src/modules/home_screen/view/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.9312, 76.2673), // Cochin coordinates
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Map (Background)
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),

          // 2. Top Card "Route for Today"
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text: 'Route for Today',
                      fontSize: 12.sp,
                      color: Colors.grey[600]!,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: '4 Stops Remaining',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textnaturalcolor,
                        ),
                        AppText(
                          text: '12.5 KM',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      text: 'ETA 56 Mins',
                      fontSize: 12.sp,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Sheet (Draggable or Fixed)
          // Using DraggableScrollableSheet for realistic feel
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Current Order Section
                    AppText(
                      text: 'Order ID : #ORD123456455',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textnaturalcolor,
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      text: 'Sarah James',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textnaturalcolor,
                    ),
                    AppText(
                      text: 'XYZ Mall GHI Road, Cochin, 682016',
                      fontSize: 13.sp,
                      color: Colors.grey[600]!,
                    ),
                    SizedBox(height: 16.h),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Mock navigation to details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(
                                    order: {
                                      'id': '#ORD123456455',
                                      'distance': '15 KM',
                                      'time': '11:00 AM - 1:00 PM',
                                      'address':
                                          'Sarah James, XYZ Mall GHI Road, Cochin, 682016',
                                      'amount': '',
                                      'isPrePaid': true,
                                      'buttonText':
                                          'View Details', // Changed to View Details as per logic
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.inventory_2_outlined,
                              size: 18.sp,
                              color: Colors.black,
                            ),
                            label: AppText(
                              text: 'View Details',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.phone_outlined,
                              size: 18.sp,
                              color: Colors.black,
                            ),
                            label: AppText(
                              text: 'Call Customer',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Next Stop Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Next Stop',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textnaturalcolor,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: AppText(
                            text: 'View All',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // List of next stops (Mock)
                    _buildNextStopItem(
                      id: '#ORD123456455',
                      name: 'Sarah James',
                      address: 'XYZ Mall GHI Road, Cochin',
                      eta: '12 Mins',
                    ),
                    SizedBox(height: 12.h),
                    _buildNextStopItem(
                      id: '#ORD123456455',
                      name: 'Sarah James',
                      address: 'XYZ Mall GHI Road, Cochin',
                      eta: '12 Mins',
                    ),
                    SizedBox(height: 12.h),
                    _buildNextStopItem(
                      id: '#ORD123456455',
                      name: 'Sarah James',
                      address: 'XYZ Mall GHI Road, Cochin',
                      eta: '12 Mins',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextStopItem({
    required String id,
    required String name,
    required String address,
    required String eta,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: Colors.red),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Order ID : $id',
                  fontSize: 12.sp,
                  color: AppColors.textnaturalcolor,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(
                      fontSize: 13.sp,
                      color: AppColors.textnaturalcolor,
                    ),
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' - $address',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: 'ETA $eta',
                  fontSize: 12.sp,
                  color: Colors.grey[500]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
