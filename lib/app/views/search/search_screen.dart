import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../controllers/product_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _productController = Get.find<ProductController>();
  final _recentSearches = <String>[].obs;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      _productController.searchProducts(query.trim());
      if (!_recentSearches.contains(query.trim())) {
        _recentSearches.insert(0, query.trim());
        if (_recentSearches.length > 10) _recentSearches.removeLast();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.grey),
          ),
          onSubmitted: _onSearch,
          onChanged: (value) {
            if (value.length > 2) {
              _onSearch(value);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _productController.products.clear();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_productController.products.isEmpty) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_recentSearches.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _recentSearches.clear(),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentSearches.map((search) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = search;
                          _onSearch(search);
                        },
                        child: Chip(
                          label: Text(search),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDelete: () => _recentSearches.remove(search),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                const Text(
                  'Popular Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Shirts', 'Shoes', 'Electronics', 'Fashion', 'Home'].map((tag) {
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = tag;
                        _onSearch(tag);
                      },
                      child: Chip(
                        label: Text(tag),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: TextStyle(color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _productController.products.length,
          itemBuilder: (context, index) {
            final product = _productController.products[index];
            return GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.productDetails,
                arguments: product.id,
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: product.image != null
                            ? CachedNetworkImage(
                                imageUrl: product.image!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppColors.greyLight,
                                child: const Icon(Icons.image),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                              const SizedBox(width: 4),
                              Text(
                                product.averageRating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Helpers.formatPrice(product.price),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
