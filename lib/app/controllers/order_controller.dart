import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderController extends GetxController {
  final _api = ApiService();
  final orders = <Order>[].obs;
  final currentOrder = Rxn<Order>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;

  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
      orders.clear();
    }

    try {
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _api.getOrders(page: currentPage.value);

      if (response.statusCode == 200) {
        final List<Order> newOrders =
            (response.data as List).map((e) => Order.fromJson(e)).toList();
        if (newOrders.length < 10) {
          hasMore.value = false;
        }
        if (currentPage.value == 1) {
          orders.value = newOrders;
        } else {
          orders.addAll(newOrders);
        }
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<Order?> fetchOrderDetails(int id) async {
    try {
      isLoading.value = true;
      final response = await _api.getOrder(id);
      if (response.statusCode == 200) {
        currentOrder.value = Order.fromJson(response.data);
        return currentOrder.value;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order details');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> createOrder(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await _api.createOrder(data);
      if (response.statusCode == 201) {
        currentOrder.value = Order.fromJson(response.data);
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order');
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}
