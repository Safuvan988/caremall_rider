class WithdrawalRequestModel {
  final bool? success;
  final int? count;
  final List<WithdrawalRequest>? requests;

  WithdrawalRequestModel({this.success, this.count, this.requests});

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequestModel(
      success: json['success'],
      count: json['count'],
      requests: json['requests'] != null
          ? List<WithdrawalRequest>.from(
              json['requests'].map((x) => WithdrawalRequest.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'requests': requests?.map((x) => x.toJson()).toList(),
    };
  }
}

class WithdrawalRequest {
  final String? id;
  final String? rider;
  final num? amount;
  final String? status;
  final String? paymentMode;
  final String? note;
  final String? adminNote;
  final DateTime? processedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WithdrawalRequest({
    this.id,
    this.rider,
    this.amount,
    this.status,
    this.paymentMode,
    this.note,
    this.adminNote,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['_id'],
      rider: json['rider'],
      amount: json['amount'],
      status: json['status'],
      paymentMode: json['paymentMode'],
      note: json['note'],
      adminNote: json['adminNote'],
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'rider': rider,
      'amount': amount,
      'status': status,
      'paymentMode': paymentMode,
      'note': note,
      'adminNote': adminNote,
      'processedAt': processedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
