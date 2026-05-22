class CartItem {
  final int productId;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String? variationId;
  final Map<String, String> selectedVariations;

  CartItem({
    required this.productId,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    this.variationId,
    required this.selectedVariations,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    int? quantity,
    String? variationId,
    Map<String, String>? selectedVariations,
  }) {
    return CartItem(
      productId: productId,
      name: name,
      image: image,
      price: price,
      quantity: quantity ?? this.quantity,
      variationId: variationId ?? this.variationId,
      selectedVariations: selectedVariations ?? this.selectedVariations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'variation_id': variationId,
      'selected_variations': selectedVariations,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      variationId: json['variation_id'],
      selectedVariations: Map<String, String>.from(json['selected_variations'] ?? {}),
    );
  }
}
