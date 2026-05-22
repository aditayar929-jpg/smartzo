import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final _api = ApiService();
  final products = <Product>[].obs;
  final featuredProducts = <Product>[].obs;
  final categories = <Category>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchFeaturedProducts();
    fetchProducts();
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
      products.clear();
    }
    if (isLoading.value || isLoadingMore.value) return;

    try {
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _api.getProducts(
        page: currentPage.value,
        category: selectedCategory.value.isNotEmpty ? selectedCategory.value : null,
      );

      if (response.statusCode == 200) {
        final List<Product> newProducts =
            (response.data as List).map((e) => Product.fromJson(e)).toList();
        if (newProducts.length < 20) {
          hasMore.value = false;
        }
        if (currentPage.value == 1) {
          products.value = newProducts;
        } else {
          products.addAll(newProducts);
        }
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      final response = await _api.getFeaturedProducts();
      if (response.statusCode == 200) {
        featuredProducts.value =
            (response.data as List).map((e) => Product.fromJson(e)).toList();
      }
    } catch (_) {}
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _api.getCategories();
      if (response.statusCode == 200) {
        categories.value =
            (response.data as List).map((e) => Category.fromJson(e)).toList();
      }
    } catch (_) {}
  }

  Future<Product?> fetchProductDetails(int id) async {
    try {
      isLoading.value = true;
      final response = await _api.getProduct(id);
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  void filterByCategory(String categoryId) {
    selectedCategory.value = categoryId;
    fetchProducts(refresh: true);
  }

  void clearFilter() {
    if (selectedCategory.value.isNotEmpty) {
      selectedCategory.value = '';
      fetchProducts(refresh: true);
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      isLoading.value = true;
      final response = await _api.getProducts(search: query);
      if (response.statusCode == 200) {
        products.value =
            (response.data as List).map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Search failed');
    } finally {
      isLoading.value = false;
    }
  }
}
