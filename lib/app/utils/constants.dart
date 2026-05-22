class AppConstants {
  // WooCommerce API Keys - CHANGE THESE
  static const String baseUrl = 'https://your-woo-commerce-site.com/wp-json/wc/v3';
  static const String authUrl = 'https://your-woo-commerce-site.com/wp-json/jwt-auth/v1';
  static const String consumerKey = 'YOUR_CONSUMER_KEY';
  static const String consumerSecret = 'YOUR_CONSUMER_SECRET';

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
