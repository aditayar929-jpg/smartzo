class Address {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final bool isDefault;

  Address({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    this.isDefault = false,
  });

  String get fullAddress => '$address1, $address2, $city, $state - $postcode';
  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      address1: json['address_1'] ?? '',
      address2: json['address_2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Address copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
