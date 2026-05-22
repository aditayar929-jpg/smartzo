import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WishlistController extends GetxController {
  final _api = ApiService();
  final productIds = <int>[].obs;
  final products = <Product>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadWishlist();
  }

  void _loadWishlist() {
    productIds.value = StorageService.getWishlist();
    if (productIds.isNotEmpty) {
      fetchWishlistProducts();
    }
  }

  Future<void> fetchWishlistProducts() async {
    try {
      isLoading.value = true;
      final List<Product> loaded = [];
      for (int id in productIds) {
        try {
          final response = await _api.getProduct(id);
          if (response.statusCode == 200) {
            loaded.add(Product.fromJson(response.data));
          }
        } catch (_) {}
      }
      products.value = loaded;
    } finally {
      isLoading.value = false;
    }
  }

  bool isWishlisted(int productId) {
    return productIds.contains(productId);
  }

  void toggleWishlist(int productId) {
    if (productIds.contains(productId)) {
      productIds.remove(productId);
      products.removeWhere((p) => p.id == productId);
      Get.snackbar('Removed', 'Removed from wishlist');
    } else {
      productIds.add(productId);
      Get.snackbar('Added', 'Added to wishlist');
    }
    StorageService.saveWishlist(productIds);
  }

  void removeFromWishlist(int productId) {
    productIds.remove(productId);
    products.removeWhere((p) => p.id == productId);
    StorageService.saveWishlist(productIds);
  }
}
