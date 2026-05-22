import 'package:dio/dio.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth params for WooCommerce API
        options.queryParameters.addAll({
          'consumer_key': AppConstants.consumerKey,
          'consumer_secret': AppConstants.consumerSecret,
        });
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  // Products
  Future<Response> getProducts({int page = 1, int perPage = 20, String? category, String? search, String? orderby}) async {
    Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
    };
    if (category != null) params['category'] = category;
    if (search != null) params['search'] = search;
    if (orderby != null) params['orderby'] = orderby;
    return _dio.get('/products', queryParameters: params);
  }

  Future<Response> getProduct(int id) async {
    return _dio.get('/products/$id');
  }

  Future<Response> getFeaturedProducts() async {
    return _dio.get('/products', queryParameters: {'featured': true});
  }

  // Categories
  Future<Response> getCategories({int page = 1, int perPage = 50}) async {
    return _dio.get('/products/categories', queryParameters: {
      'page': page,
      'per_page': perPage,
    });
  }

  // Authentication
  Future<Response> login(String username, String password) async {
    return _dio.post(
      '${AppConstants.authUrl}/token',
      data: {'username': username, 'password': password},
      options: Options(extra: {'noAuth': true}),
    );
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return _dio.post('/customers', data: data);
  }

  // Orders
  Future<Response> getOrders({int page = 1, String? status}) async {
    Map<String, dynamic> params = {'page': page};
    if (status != null) params['status'] = status;
    return _dio.get('/orders', queryParameters: params);
  }

  Future<Response> getOrder(int id) async {
    return _dio.get('/orders/$id');
  }

  Future<Response> createOrder(Map<String, dynamic> data) async {
    return _dio.post('/orders', data: data);
  }

  // Customer
  Future<Response> getCustomer(int id) async {
    return _dio.get('/customers/$id');
  }

  Future<Response> updateCustomer(int id, Map<String, dynamic> data) async {
    return _dio.put('/customers/$id', data: data);
  }

  // Coupons
  Future<Response> getCoupons() async {
    return _dio.get('/coupons');
  }

  Future<Response> validateCoupon(String code) async {
    return _dio.get('/coupons', queryParameters: {'code': code});
  }

  // Reviews
  Future<Response> getReviews(int productId) async {
    return _dio.get('/products/reviews', queryParameters: {'product': productId});
  }

  Future<Response> createReview(Map<String, dynamic> data) async {
    return _dio.post('/products/reviews', data: data);
  }
}
