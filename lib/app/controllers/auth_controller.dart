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
      final response = await _api.login(email, password);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await StorageService.saveToken(token);
        // Fetch user data
        final userResponse = await _api.getCustomer(response.data['user_id']);
        if (userResponse.statusCode == 200) {
          user.value = User.fromJson(userResponse.data);
          user.value = User(
            id: user.value!.id,
            email: user.value!.email,
            firstName: user.value!.firstName,
            lastName: user.value!.lastName,
            avatar: user.value!.avatar,
            phone: user.value!.phone,
            token: token,
          );
          await StorageService.saveUser(user.value!.toJson());
          isLoggedIn.value = true;
          Get.offAllNamed(AppRoutes.home);
          return true;
        }
      }
      return false;
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
      final response = await _api.register({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': email,
        'password': password,
      });
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Registration successful! Please login.');
        Get.offNamed(AppRoutes.login);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUser();
    user.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  bool get isAuthenticated => isLoggedIn.value && user.value != null;
}
