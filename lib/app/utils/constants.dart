class AppConstants {
  // WooCommerce API Keys - CHANGE THESE
  static const String baseUrl = 'https://smartzo.shop/wp-json/wc/v3';
  static const String authUrl = 'https://smartzo.shop/wp-json/jwt-auth/v1';
  static const String consumerKey = 'ck_3bbfc8bf49901fa8074999b45da2781a37d34ce3';
  static const String consumerSecret = 'cs_2936c22fce485301ee0f4e6b949a26bd325c4541';

  // App Info
  static const String appName = 'Smartzo';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;

  // Razorpay
  static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_ID';

  // Firebase
  static const String fcmTopic = 'smartzo_notifications';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);

  // Image Placeholders
  static const String placeholderImage = 'https://via.placeholder.com/300';
  static const String placeholderAvatar = 'https://via.placeholder.com/150';
}
