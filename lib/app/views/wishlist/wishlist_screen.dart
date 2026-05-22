import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../controllers/wishlist_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishlistController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          Obx(() => controller.products.isNotEmpty
              ? TextButton(
                  onPressed: () {
                    for (var product in controller.products) {
                      cartController.addItem(CartItem(
                        productId: product.id,
                        name: product.name,
                        image: product.image,
                        price: double.tryParse(product.price) ?? 0,
                        quantity: 1,
                        selectedVariations: {},
                      ));
                    }
                    Get.snackbar('Added', 'All items added to cart');
                  },
                  child: const Text('Add All to Cart'),
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 100, color: AppColors.greyLight),
                const SizedBox(height: 24),
                const Text(
                  'Your wishlist is empty',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Save items you love',
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: const Text('Explore Products'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Dismissible(
              key: Key(product.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: AppColors.error,
                child: const Icon(Icons.delete, color: AppColors.white),
              ),
              onDismissed: (_) => controller.removeFromWishlist(product.id),
              child: GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoutes.productDetails,
                  arguments: product.id,
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 100,
                          height: 100,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Helpers.formatPrice(product.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite, color: AppColors.error),
                            onPressed: () => controller.removeFromWishlist(product.id),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              cartController.addItem(CartItem(
                                productId: product.id,
                                name: product.name,
                                image: product.image,
                                price: double.tryParse(product.price) ?? 0,
                                quantity: 1,
                                selectedVariations: {},
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
