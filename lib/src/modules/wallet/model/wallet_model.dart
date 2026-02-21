class WalletModel {
  final bool? success;
  final num? balance;
  final num? totalEarned;
  final num? totalWithdrawn;
  final List<Transaction>? transactions;

  WalletModel({
    this.success,
    this.balance,
    this.totalEarned,
    this.totalWithdrawn,
    this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      success: json['success'],
      balance: json['balance'],
      totalEarned: json['totalEarned'],
      totalWithdrawn: json['totalWithdrawn'],
      transactions: json['transactions'] != null
          ? List<Transaction>.from(
              json['transactions'].map((x) => Transaction.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'balance': balance,
      'totalEarned': totalEarned,
      'totalWithdrawn': totalWithdrawn,
      'transactions': transactions?.map((x) => x.toJson()).toList(),
    };
  }
}

class Transaction {
  final String? id;
  final String? type;
  final num? amount;
  final String? description;
  final String? referenceId;
  final String? referenceModel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Transaction({
    this.id,
    this.type,
    this.amount,
    this.description,
    this.referenceId,
    this.referenceModel,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      referenceId: json['referenceId'],
      referenceModel: json['referenceModel'],
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
      'type': type,
      'amount': amount,
      'description': description,
      'referenceId': referenceId,
      'referenceModel': referenceModel,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
