class WalletTransaction {
  final int id;
  final String direction;
  final double amount;
  final String type;
  final String status;
  final String? idempotencyKey;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.direction,
    required this.amount,
    required this.type,
    required this.status,
    this.idempotencyKey,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      direction: json['direction'],
      amount: double.parse(json['amount'].toString()),
      type: json['type'],
      status: json['status'],
      idempotencyKey: json['idempotency_key'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
