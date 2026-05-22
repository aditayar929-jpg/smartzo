import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  static String? getToken() {
    return _prefs.getString('auth_token');
  }

  static Future<void> removeToken() async {
    await _prefs.remove('auth_token');
  }

  // User Data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString('user_data', jsonEncode(user));
  }

  static Map<String, dynamic>? getUser() {
    final data = _prefs.getString('user_data');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static Future<void> removeUser() async {
    await _prefs.remove('user_data');
  }

  // Onboarding
  static Future<void> setOnboardingDone() async {
    await _prefs.setBool('onboarding_done', true);
  }

  static bool isOnboardingDone() {
    return _prefs.getBool('onboarding_done') ?? false;
  }

  // Cart
  static Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    await _prefs.setString('cart_data', jsonEncode(cart));
  }

  static List<Map<String, dynamic>> getCart() {
    final data = _prefs.getString('cart_data');
    if (data != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    return [];
  }

  // Wishlist
  static Future<void> saveWishlist(List<int> ids) async {
    await _prefs.setString('wishlist_ids', jsonEncode(ids));
  }

  static List<int> getWishlist() {
    final data = _prefs.getString('wishlist_ids');
    if (data != null) {
      return List<int>.from(jsonDecode(data));
    }
    return [];
  }

  // Dark Mode
  static Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('dark_mode', value);
  }

  static bool isDarkMode() {
    return _prefs.getBool('dark_mode') ?? false;
  }

  // Clear All
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
