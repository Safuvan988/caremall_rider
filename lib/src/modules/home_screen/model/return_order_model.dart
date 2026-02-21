class ReturnOrder {
  final String id;
  final String returnId;
  final String orderStatus;
  final String? reason;
  final double totalAmount;
  final String? customerName;
  final String? customerPhone;
  final String? address;
  final DateTime? createdAt;

  ReturnOrder({
    required this.id,
    required this.returnId,
    required this.orderStatus,
    this.reason,
    required this.totalAmount,
    this.customerName,
    this.customerPhone,
    this.address,
    this.createdAt,
  });

  factory ReturnOrder.fromJson(Map<String, dynamic> json) {
    // Support both top-level and nested customer / address data
    final customer = json['customer'];
    final shipping = json['shippingAddress'] ?? json['address'];

    String customerName = '';
    String customerPhone = '';
    String address = '';

    if (customer is Map) {
      customerName =
          '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();
      customerPhone = (customer['phone'] ?? '').toString();
    }
    if (shipping is Map) {
      if (customerName.isEmpty) {
        customerName = '${shipping['fullName'] ?? shipping['firstName'] ?? ''}'
            .trim();
      }
      if (customerPhone.isEmpty) {
        customerPhone = (shipping['phone'] ?? '').toString();
      }
      final parts = [
        shipping['addressLine1'],
        shipping['addressLine2'],
        shipping['city'],
        shipping['state'],
        shipping['pincode'],
      ].where((p) => p != null && p.toString().isNotEmpty).toList();
      address = parts.join(', ');
    }

    return ReturnOrder(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      returnId: (json['returnId'] ?? json['_id'] ?? '').toString(),
      orderStatus: (json['status'] ?? json['orderStatus'] ?? 'pending')
          .toString()
          .toLowerCase(),
      reason: json['reason']?.toString(),
      totalAmount: (json['totalAmount'] ?? json['amount'] ?? 0).toDouble(),
      customerName: customerName.isEmpty ? null : customerName,
      customerPhone: customerPhone.isEmpty ? null : customerPhone,
      address: address.isEmpty ? null : address,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
