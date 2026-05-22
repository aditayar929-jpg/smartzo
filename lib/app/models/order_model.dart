class Order {
  final int id;
  final String status;
  final String dateCreated;
  final String total;
  final List<OrderItem> items;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.status,
    required this.dateCreated,
    required this.total,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      dateCreated: json['date_created'] ?? '',
      total: json['total'] ?? '0',
      items: (json['line_items'] as List?)?.map((e) => OrderItem.fromJson(e)).toList() ?? [],
      shippingAddress: ShippingAddress.fromJson(json['shipping'] ?? {}),
      paymentMethod: json['payment_method_title'] ?? '',
      trackingNumber: json['meta_data']?.firstWhere(
        (m) => m['key'] == '_tracking_number',
        orElse: () => {'value': null},
      )['value'],
    );
  }
}

class OrderItem {
  final int productId;
  final String name;
  final int quantity;
  final String total;
  final String? image;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.total,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      total: json['total'] ?? '0',
      image: json['image']?['src'],
    );
  }
}

class ShippingAddress {
  final String firstName;
  final String lastName;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String phone;

  ShippingAddress({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.phone,
  });

  String get fullAddress => '$address1, $address2, $city, $state - $postcode';

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address1: json['address_1'] ?? '',
      address2: json['address_2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
