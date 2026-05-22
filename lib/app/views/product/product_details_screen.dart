import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import '../../theme/app_colors.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _productController = Get.find<ProductController>();
  final _cartController = Get.find<CartController>();
  final _wishlistController = Get.find<WishlistController>();
  int _currentImageIndex = 0;
  int _quantity = 1;
  Map<String, String> _selectedVariations = {};
  Product? _product;

  @override
  Widget build(BuildContext context) {
    final int productId = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder(
        future: _productController.fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: AppColors.grey),
                  const SizedBox(height: 16),
                  const Text('Product not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          _product = snapshot.data!;
          final product = _product!;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppColors.white,
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.black),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => _wishlistController.toggleWishlist(product.id),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Obx(() => Icon(
                        _wishlistController.isWishlisted(product.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _wishlistController.isWishlisted(product.id)
                            ? AppColors.error
                            : AppColors.black,
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Share.share(
                      'Check out ${product.name} on Smartzo!',
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.share, color: AppColors.black),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        itemCount: product.images.length,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: product.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentImageIndex == index ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index
                                    ? AppColors.primary
                                    : AppColors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: product.averageRating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color(0xFFFFC107),
                            ),
                            itemCount: 5,
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.averageRating} (${product.ratingCount} reviews)',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Row(
                        children: [
                          Text(
                            Helpers.formatPrice(product.price),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (product.onSale) ...[
                            const SizedBox(width: 12),
                            Text(
                              Helpers.formatPrice(product.regularPrice),
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${((double.parse(product.regularPrice) - double.parse(product.price)) / double.parse(product.regularPrice) * 100).round()}% OFF',
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Stock Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: product.inStock
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: product.inStock ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Variations
                      if (product.attributes.isNotEmpty) ...[
                        const Text(
                          'Select Options',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...product.attributes.map((attr) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attr.name,
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: attr.options.map((option) {
                                  final isSelected =
                                      _selectedVariations[attr.name] == option;
                                  return ChoiceChip(
                                    label: Text(option),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedVariations[attr.name] = option;
                                        } else {
                                          _selectedVariations.remove(attr.name);
                                        }
                                      });
                                    },
                                    selectedColor: AppColors.primary,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.black,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                      ],

                      // Quantity
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _quantity.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onTap: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description.replaceAll(RegExp(r'<[^>]*>'), ''),
                        style: TextStyle(
                          color: AppColors.greyDark,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Reviews
                      if (product.reviews.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                        ...product.reviews.take(3).map((review) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      review.reviewer,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: review.rating,
                                      itemBuilder: (context, index) => const Icon(
                                        Icons.star,
                                        color: Color(0xFFFFC107),
                                      ),
                                      itemCount: 5,
                                      itemSize: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.review,
                                  style: TextStyle(
                                    color: AppColors.greyDark,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                      ],

                      // Related Products
                      if (product.relatedProducts.isNotEmpty) ...[
                        const Text(
                          'Related Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.relatedProducts.length,
                            itemBuilder: (context, index) {
                              final related = product.relatedProducts[index];
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  AppRoutes.productDetails,
                                  arguments: related.id,
                                ),
                                child: Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: SizedBox(
                                          height: 120,
                                          width: double.infinity,
                                          child: related.image != null
                                              ? CachedNetworkImage(
                                                  imageUrl: related.image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  color: AppColors.greyLight,
                                                  child: const Icon(Icons.image),
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              related.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Helpers.formatPrice(related.price),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _product == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Add to Cart
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _cartController.addItem(CartItem(
                          productId: _product!.id,
                          name: _product!.name,
                          image: _product!.image,
                          price: double.tryParse(_product!.price) ?? 0,
                          quantity: _quantity,
                          variationId: _selectedVariations.isNotEmpty ? _selectedVariations.toString() : null,
                          selectedVariations: _selectedVariations,
                        ));
                        Get.snackbar('Added', '${_product!.name} added to cart',
                            snackPosition: SnackPosition.BOTTOM);
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Buy Now
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _cartController.addItem(CartItem(
                          productId: _product!.id,
                          name: _product!.name,
                          image: _product!.image,
                          price: double.tryParse(_product!.price) ?? 0,
                          quantity: _quantity,
                          variationId: _selectedVariations.isNotEmpty ? _selectedVariations.toString() : null,
                          selectedVariations: _selectedVariations,
                        ));
                        Get.toNamed(AppRoutes.checkout);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
