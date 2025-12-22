class WalletTransaction {
  final int id;
  final String direction;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String type;
  final int referanceId;
  final String status;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.direction,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.type,
    required this.referanceId,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      direction: json['direction'],
      amount: double.parse(json['amount'].toString()),
      balanceBefore: double.parse(json['balance_before'].toString()),
      balanceAfter: double.parse(json['balance_after'].toString()),
      type: json['type'],
      referanceId: json['reference_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
