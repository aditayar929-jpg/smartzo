class Coupon {
  final int id;
  final String code;
  final String discountType;
  final String amount;
  final String? description;
  final String? minimumAmount;
  final String? maximumAmount;
  final String? expiryDate;
  final int usageLimit;
  final int usageCount;

  Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.amount,
    this.description,
    this.minimumAmount,
    this.maximumAmount,
    this.expiryDate,
    required this.usageLimit,
    required this.usageCount,
  });

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.parse(expiryDate!).isBefore(DateTime.now());
  }

  bool get isAvailable => !isExpired && (usageLimit == 0 || usageCount < usageLimit);

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      discountType: json['discount_type'] ?? '',
      amount: json['amount'] ?? '0',
      description: json['description'],
      minimumAmount: json['minimum_amount'],
      maximumAmount: json['maximum_amount'],
      expiryDate: json['expiry_date'],
      usageLimit: json['usage_limit'] ?? 0,
      usageCount: json['usage_count'] ?? 0,
    );
  }
}
