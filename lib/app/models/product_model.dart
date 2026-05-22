class Product {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String shortDescription;
  final String price;
  final String regularPrice;
  final String salePrice;
  final bool onSale;
  final String? image;
  final List<String> images;
  final List<ProductVariation> variations;
  final double averageRating;
  final int ratingCount;
  final List<ProductReview> reviews;
  final List<Category> categories;
  final List<ProductAttribute> attributes;
  final int stockQuantity;
  final bool inStock;
  final bool featured;
  final List<RelatedProduct> relatedProducts;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    this.image,
    required this.images,
    required this.variations,
    required this.averageRating,
    required this.ratingCount,
    required this.reviews,
    required this.categories,
    required this.attributes,
    required this.stockQuantity,
    required this.inStock,
    required this.featured,
    required this.relatedProducts,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_description'] ?? '',
      price: json['price'] ?? '0',
      regularPrice: json['regular_price'] ?? '0',
      salePrice: json['sale_price'] ?? '0',
      onSale: json['on_sale'] ?? false,
      image: json['images']?.isNotEmpty == true ? json['images'][0]['src'] : null,
      images: (json['images'] as List?)?.map((e) => e['src'].toString()).toList() ?? [],
      variations: (json['variations'] as List?)?.map((e) => ProductVariation.fromJson(e)).toList() ?? [],
      averageRating: double.tryParse(json['average_rating'] ?? '0') ?? 0,
      ratingCount: json['rating_count'] ?? 0,
      reviews: (json['reviews'] as List?)?.map((e) => ProductReview.fromJson(e)).toList() ?? [],
      categories: (json['categories'] as List?)?.map((e) => Category.fromJson(e)).toList() ?? [],
      attributes: (json['attributes'] as List?)?.map((e) => ProductAttribute.fromJson(e)).toList() ?? [],
      stockQuantity: json['stock_quantity'] ?? 0,
      inStock: json['in_stock'] ?? true,
      featured: json['featured'] ?? false,
      relatedProducts: (json['related_products'] as List?)?.map((e) => RelatedProduct.fromJson(e)).toList() ?? [],
    );
  }
}

class ProductVariation {
  final int id;
  final String price;
  final String? image;
  final Map<String, String> attributes;

  ProductVariation({
    required this.id,
    required this.price,
    this.image,
    required this.attributes,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] ?? 0,
      price: json['price'] ?? '0',
      image: json['image']?['src'],
      attributes: Map<String, String>.from(
        (json['attributes'] as Map?)?.map((k, v) => MapEntry(k.toString(), v.toString())) ?? {},
      ),
    );
  }
}

class ProductAttribute {
  final int id;
  final String name;
  final List<String> options;

  ProductAttribute({
    required this.id,
    required this.name,
    required this.options,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

class ProductReview {
  final int id;
  final String reviewer;
  final String review;
  final double rating;
  final String date;

  ProductReview({
    required this.id,
    required this.reviewer,
    required this.review,
    required this.rating,
    required this.date,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] ?? 0,
      reviewer: json['reviewer'] ?? '',
      review: json['review'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      date: json['date_created'] ?? '',
    );
  }
}

class RelatedProduct {
  final int id;
  final String name;
  final String? image;
  final String price;

  RelatedProduct({
    required this.id,
    required this.name,
    this.image,
    required this.price,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['images']?.isNotEmpty == true ? json['images'][0]['src'] : null,
      price: json['price'] ?? '0',
    );
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    required this.count,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image']?['src'],
      count: json['count'] ?? 0,
    );
  }
}
