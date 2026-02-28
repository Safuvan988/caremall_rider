class DashboardSummary {
  final num todayCodCollected;
  final int todayDeliveries;
  final int pendingOrders;
  final int totalDeliveries;
  final num totalCodCollected;
  final num walletBalance;
  final num totalEarned;

  const DashboardSummary({
    required this.todayCodCollected,
    required this.todayDeliveries,
    required this.pendingOrders,
    required this.totalDeliveries,
    required this.totalCodCollected,
    required this.walletBalance,
    required this.totalEarned,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      todayCodCollected: (json['todayCodCollected'] as num?) ?? 0,
      todayDeliveries: (json['todayDeliveries'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      totalCodCollected: (json['totalCodCollected'] as num?) ?? 0,
      walletBalance: (json['walletBalance'] as num?) ?? 0,
      totalEarned: (json['totalEarned'] as num?) ?? 0,
    );
  }
}

class TodayOrderAddress {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String city;
  final String district;
  final String postalCode;

  const TodayOrderAddress({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    required this.city,
    required this.district,
    required this.postalCode,
  });

  factory TodayOrderAddress.fromJson(Map<String, dynamic> json) {
    return TodayOrderAddress(
      fullName: (json['fullName'] ?? json['name'] ?? '-').toString(),
      phone: (json['phone'] ?? '-').toString(),
      addressLine1: (json['addressLine1'] ?? json['address'] ?? '-').toString(),
      city: (json['city'] ?? '-').toString(),
      district: (json['district'] ?? '-').toString(),
      postalCode: (json['postalCode'] ?? '-').toString(),
    );
  }
}

class TodayOrder {
  final String id;
  final String orderId;
  final String orderStatus;
  final String paymentMethod;
  final num finalAmount;
  final num codCharge;
  final bool isDelivered;
  final DateTime? deliveredAt;
  final TodayOrderAddress shippingAddress;
  final String dispatchStatus;

  const TodayOrder({
    required this.id,
    required this.orderId,
    required this.orderStatus,
    required this.paymentMethod,
    required this.finalAmount,
    required this.codCharge,
    required this.isDelivered,
    this.deliveredAt,
    required this.shippingAddress,
    required this.dispatchStatus,
  });

  bool get isCod => paymentMethod.toLowerCase() == 'cod';

  factory TodayOrder.fromJson(Map<String, dynamic> json) {
    final addr = json['shippingAddress'];
    final dispatch = json['dispatch'];

    // The backend seems to use 'totalAmount' in the orders list
    final amount = (json['totalAmount'] ?? json['finalAmount'] ?? 0) as num;

    return TodayOrder(
      id: json['_id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '-',
      orderStatus: json['orderStatus']?.toString() ?? '-',
      paymentMethod: json['paymentMethod']?.toString() ?? '-',
      finalAmount: amount,
      codCharge: (json['codCharge'] as num?) ?? 0,
      isDelivered:
          json['isDelivered'] == true || json['orderStatus'] == 'delivered',
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.tryParse(json['deliveredAt'].toString())
          : null,
      shippingAddress: addr is Map<String, dynamic>
          ? TodayOrderAddress.fromJson(addr)
          : const TodayOrderAddress(
              fullName: '-',
              phone: '-',
              addressLine1: '-',
              city: '-',
              district: '-',
              postalCode: '-',
            ),
      dispatchStatus: dispatch is Map<String, dynamic>
          ? (dispatch['status']?.toString() ?? '-')
          : (json['dispatchStatus']?.toString() ?? '-'),
    );
  }
}

class DashboardModel {
  final bool success;
  final String date;
  final DashboardSummary summary;
  final List<TodayOrder> todayOrders;

  const DashboardModel({
    required this.success,
    required this.date,
    required this.summary,
    required this.todayOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    var rawSummary = json['summary'];
    // Fallback to 'orders' if 'todayOrders' is missing
    final rawOrders = json['todayOrders'] ?? json['orders'];

    final List<TodayOrder> allOrders = rawOrders is List
        ? rawOrders
              .map((e) => TodayOrder.fromJson(e as Map<String, dynamic>))
              .toList()
        : [];

    // Filter to only show orders delivered TODAY on this specific screen
    final now = DateTime.now();
    final orders = allOrders.where((o) {
      if (o.orderStatus.toLowerCase() != 'delivered' || o.deliveredAt == null) {
        return false;
      }
      final d = o.deliveredAt!.toLocal();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();

    // If summary is missing, calculate it locally for "Today"
    if (rawSummary == null) {
      final now = DateTime.now();
      final todayOrders = orders.where((o) {
        if (o.deliveredAt == null) return false;
        final d = o.deliveredAt!.toLocal();
        return d.year == now.year && d.month == now.month && d.day == now.day;
      }).toList();

      double cod = 0;
      for (var o in todayOrders) {
        if (o.paymentMethod.toLowerCase() == 'cod') {
          cod += o.finalAmount;
        }
      }

      rawSummary = {
        'todayCodCollected': cod,
        'todayDeliveries': todayOrders.length,
        'pendingOrders': orders
            .where((o) => !o.isDelivered && o.orderStatus != 'cancelled')
            .length,
        'totalDeliveries': orders.where((o) => o.isDelivered).length,
        'totalCodCollected': cod, // Placeholder
        'walletBalance': 0,
        'totalEarned': 0,
      };
    }

    return DashboardModel(
      success: json['success'] == true,
      date: json['date']?.toString() ?? '',
      summary: DashboardSummary.fromJson(rawSummary as Map<String, dynamic>),
      todayOrders: orders,
    );
  }
}
