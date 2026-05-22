import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/splash/splash_screen.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/auth/otp_verification_screen.dart';
import '../views/home/home_screen.dart';
import '../views/product/product_list_screen.dart';
import '../views/product/product_details_screen.dart';
import '../views/search/search_screen.dart';
import '../views/cart/cart_screen.dart';
import '../views/checkout/checkout_screen.dart';
import '../views/checkout/order_success_screen.dart';
import '../views/orders/orders_screen.dart';
import '../views/orders/order_details_screen.dart';
import '../views/wishlist/wishlist_screen.dart';
import '../views/profile/profile_screen.dart';
import '../views/profile/edit_profile_screen.dart';
import '../views/notifications/notifications_screen.dart';
import '../views/coupons/coupons_screen.dart';
import '../views/address/address_screen.dart';
import '../views/address/add_address_screen.dart';
import '../views/support/customer_support_screen.dart';
import '../views/settings/settings_screen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: AppRoutes.otpVerification, page: () => const OTPVerificationScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.productList, page: () => const ProductListScreen()),
    GetPage(name: AppRoutes.productDetails, page: () => const ProductDetailsScreen()),
    GetPage(name: AppRoutes.search, page: () => const SearchScreen()),
    GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: AppRoutes.orderSuccess, page: () => const OrderSuccessScreen()),
    GetPage(name: AppRoutes.orders, page: () => const OrdersScreen()),
    GetPage(name: AppRoutes.orderDetails, page: () => const OrderDetailsScreen()),
    GetPage(name: AppRoutes.wishlist, page: () => const WishlistScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsScreen()),
    GetPage(name: AppRoutes.coupons, page: () => const CouponsScreen()),
    GetPage(name: AppRoutes.address, page: () => const AddressScreen()),
    GetPage(name: AppRoutes.addAddress, page: () => const AddAddressScreen()),
    GetPage(name: AppRoutes.customerSupport, page: () => const CustomerSupportScreen()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
  ];
}
