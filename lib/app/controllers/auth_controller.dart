import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final _api = ApiService();
  final isLoading = false.obs;
  final user = Rxn<User>();
  final isLoggedIn = false.obs;
  final isGuest = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final userData = StorageService.getUser();
    final token = StorageService.getToken();
    if (userData != null && token != null) {
      user.value = User.fromJson(userData);
      isLoggedIn.value = true;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      // Step 1: Find customer by email
      final searchResponse = await _api.getCustomersByEmail(email);

      if (searchResponse.statusCode == 200) {
        final customers = searchResponse.data as List;

        if (customers.isEmpty) {
          Get.snackbar('Error', 'No account found with this email');
          return false;
        }

        final customer = customers[0];

        // Step 2: Verify password using WordPress REST API
        final verifyResponse = await _api.verifyCustomerPassword(
          customer['id'],
          password,
        );

        if (verifyResponse.statusCode == 200 && verifyResponse.data['valid'] == true) {
          // Login successful
          user.value = User.fromJson(customer);
          user.value = User(
            id: user.value!.id,
            email: user.value!.email,
            firstName: user.value!.firstName,
            lastName: user.value!.lastName,
            avatar: user.value!.avatar,
            phone: user.value!.phone,
            token: 'wc_auth_${customer['id']}',
          );
          await StorageService.saveToken(user.value!.token!);
          await StorageService.saveUser(user.value!.toJson());
          isLoggedIn.value = true;
          isGuest.value = false;
          Get.offAllNamed(AppRoutes.home);
          return true;
        } else {
          Get.snackbar('Error', 'Invalid password. Make sure you have JWT Auth plugin installed on your WooCommerce site.');
          return false;
        }
      } else {
        Get.snackbar('Error', 'Login failed. Please try again.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String firstName, String lastName, String email, String password) async {
    try {
      isLoading.value = true;

      // Create customer via WooCommerce REST API
      final response = await _api.createCustomer({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': email,
        'password': password,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Account created! Please login.');
        Get.offNamed(AppRoutes.login);
        return true;
      } else {
        final errorMsg = response.data?['message'] ?? 'Registration failed';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void continueAsGuest() {
    isGuest.value = true;
    isLoggedIn.value = false;
    user.value = null;
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUser();
    user.value = null;
    isLoggedIn.value = false;
    isGuest.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  bool get isAuthenticated => isLoggedIn.value && user.value != null;
  bool get canShop => isAuthenticated || isGuest.value;
}
