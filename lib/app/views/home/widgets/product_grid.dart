import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../theme/app_colors.dart';
import '../../../controllers/product_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helpers.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final wishlistController = Get.find<WishlistController>();

    return Obx(() {
      if (controller.isLoading.value && controller.products.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            },
          ),
        );
      }

      final products = controller.featuredProducts.isNotEmpty
          ? controller.featuredProducts
          : controller.products;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length > 10 ? 10 : products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.productDetails,
                arguments: product.id,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: product.image != null
                                ? CachedNetworkImage(
                                    imageUrl: product.image!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppColors.greyLight,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: AppColors.greyLight,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: AppColors.greyLight,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        // Sale Badge
                        if (product.onSale)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'SALE',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        // Wishlist Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => wishlistController.toggleWishlist(product.id),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Obx(() => Icon(
                                wishlistController.isWishlisted(product.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: wishlistController.isWishlisted(product.id)
                                    ? AppColors.error
                                    : AppColors.grey,
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Product Info
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFC107),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.averageRating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.ratingCount})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Price
                          Row(
                            children: [
                              Text(
                                Helpers.formatPrice(product.price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (product.onSale) ...[
                                const SizedBox(width: 8),
                                Text(
                                  Helpers.formatPrice(product.regularPrice),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
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
      );
    });
  }
}
