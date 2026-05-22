import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../controllers/cart_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Obx(() => controller.items.isNotEmpty
              ? TextButton(
                  onPressed: () => _showClearCartDialog(context, controller),
                  child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 100, color: AppColors.greyLight),
                const SizedBox(height: 24),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add items to get started',
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Container(
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
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: item.image != null
                                ? CachedNetworkImage(
                                    imageUrl: item.image!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: AppColors.greyLight,
                                    child: const Icon(Icons.image),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.selectedVariations.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.selectedVariations.entries
                                      .map((e) => '${e.key}: ${e.value}')
                                      .join(', '),
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                Helpers.formatPrice(item.price.toString()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Quantity Controls
                              Row(
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onTap: () => controller.updateQuantity(
                                      item.productId,
                                      item.variationId,
                                      item.quantity - 1,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onTap: () => controller.updateQuantity(
                                      item.productId,
                                      item.variationId,
                                      item.quantity + 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Delete
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () => controller.removeItem(
                            item.productId,
                            item.variationId,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Bar
            Container(
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
              child: Column(
                children: [
                  // Coupon
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter coupon code',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.greyLight),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Totals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(color: AppColors.grey)),
                      Text(Helpers.formatPrice(controller.subtotal.toString())),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount', style: TextStyle(color: AppColors.grey)),
                      Text(
                        '-${Helpers.formatPrice(controller.discount.toString())}',
                        style: TextStyle(color: AppColors.success),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        Helpers.formatPrice(controller.total.toString()),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.checkout),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
