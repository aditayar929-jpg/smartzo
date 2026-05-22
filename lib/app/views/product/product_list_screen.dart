import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final wishlistController = Get.find<WishlistController>();

    // Handle arguments - can be String (name) or Map (id + name)
    final args = Get.arguments;
    String? categoryName;
    String? categoryId;

    if (args is Map) {
      categoryId = args['id']?.toString();
      categoryName = args['name']?.toString();
    } else if (args is String) {
      categoryName = args;
    }

    // Filter by category when screen opens
    if (categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.filterByCategory(categoryId!);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clearFilter();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(categoryName ?? 'Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(AppRoutes.search),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            },
          );
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(fontSize: 18, color: AppColors.grey),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                controller.hasMore.value &&
                !controller.isLoadingMore.value) {
              controller.fetchProducts();
            }
            return false;
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.products.length +
                (controller.hasMore.value ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.products.length) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final product = controller.products[index];
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
                                    )
                                  : Container(
                                      color: AppColors.greyLight,
                                      child: const Icon(Icons.image),
                                    ),
                            ),
                          ),
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
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                                const SizedBox(width: 4),
                                Text(
                                  product.averageRating.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
      }),
    );
  }
}
