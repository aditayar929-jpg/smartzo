import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _cartController = Get.find<CartController>();
  final _orderController = Get.put(OrderController());
  String _selectedPayment = 'razorpay';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Home',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '123 Main Street, City, State - 123456',
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.address),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Summary
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._cartController.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: item.image != null
                            ? Image.network(item.image!, fit: BoxFit.cover)
                            : Container(
                                color: AppColors.greyLight,
                                child: const Icon(Icons.image, size: 30),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Helpers.formatPrice(item.totalPrice.toString()),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 32),

            // Payment Method
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'razorpay',
              'Razorpay',
              'UPI, Cards, Wallets',
              Icons.payment,
            ),
            _buildPaymentOption(
              'stripe',
              'Stripe',
              'Credit/Debit Cards',
              Icons.credit_card,
            ),
            _buildPaymentOption(
              'cod',
              'Cash on Delivery',
              'Pay when you receive',
              Icons.money,
            ),
            const SizedBox(height: 24),

            // Price Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', _cartController.subtotal),
                  _buildPriceRow('Shipping', 0),
                  _buildPriceRow('Discount', -_cartController.discount),
                  const Divider(),
                  _buildPriceRow('Total', _cartController.total, isBold: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePlaceOrder,
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Place Order - ${Helpers.formatPrice(_cartController.total.toString())}',
                    style: const TextStyle(fontSize: 18),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedPayment == value
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedPayment == value
                ? AppColors.primary
                : AppColors.greyLight,
            width: _selectedPayment == value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedPayment == value
                  ? AppColors.primary
                  : AppColors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _selectedPayment == value
                          ? AppColors.primary
                          : AppColors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Radio(
              value: value,
              groupValue: _selectedPayment,
              onChanged: (v) => setState(() => _selectedPayment = v!),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            Helpers.formatPrice(amount.abs().toString()),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isBold ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder() async {
    setState(() => _isLoading = true);

    // Simulate order creation
    await Future.delayed(const Duration(seconds: 2));

    _cartController.clearCart();
    setState(() => _isLoading = false);

    Get.offNamed(AppRoutes.orderSuccess);
  }
}
