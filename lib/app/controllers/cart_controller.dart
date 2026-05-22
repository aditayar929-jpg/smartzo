import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../services/storage_service.dart';

class CartController extends GetxController {
  final items = <CartItem>[].obs;
  final isLoading = false.obs;
  final couponCode = ''.obs;
  final discount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  void _loadCart() {
    final cartData = StorageService.getCart();
    items.value = cartData.map((e) => CartItem.fromJson(e)).toList();
  }

  void addItem(CartItem item) {
    final index = items.indexWhere((e) =>
        e.productId == item.productId &&
        e.variationId == item.variationId);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + item.quantity,
      );
    } else {
      items.add(item);
    }
    _saveCart();
    Get.snackbar('Added', '${item.name} added to cart',
        snackPosition: SnackPosition.BOTTOM);
  }

  void removeItem(int productId, String? variationId) {
    items.removeWhere((e) =>
        e.productId == productId && e.variationId == variationId);
    _saveCart();
  }

  void updateQuantity(int productId, String? variationId, int quantity) {
    final index = items.indexWhere((e) =>
        e.productId == productId && e.variationId == variationId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId, variationId);
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
        _saveCart();
      }
    }
  }

  void clearCart() {
    items.clear();
    _saveCart();
  }

  void applyCoupon(String code) {
    couponCode.value = code;
    // TODO: Validate coupon with API and calculate discount
    discount.value = 0;
  }

  void removeCoupon() {
    couponCode.value = '';
    discount.value = 0;
  }

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal - discount;

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  void _saveCart() {
    StorageService.saveCart(items.map((e) => e.toJson()).toList());
  }
}
