import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_routes.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {
        'id': 1,
        'name': 'Home',
        'address': '123 Main Street, Apartment 4B',
        'city': 'Mumbai, Maharashtra - 400001',
        'phone': '+91 9876543210',
        'isDefault': true,
      },
      {
        'id': 2,
        'name': 'Office',
        'address': '456 Business Park, Floor 3',
        'city': 'Mumbai, Maharashtra - 400051',
        'phone': '+91 9876543210',
        'isDefault': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('My Addresses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addAddress),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 100, color: AppColors.greyLight),
                  const SizedBox(height: 24),
                  const Text(
                    'No addresses saved',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a delivery address',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: address['isDefault'] as bool
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            address['name'] == 'Home'
                                ? Icons.home
                                : Icons.business,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            address['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (address['isDefault'] as bool) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        address['address'] as String,
                        style: TextStyle(color: AppColors.greyDark),
                      ),
                      Text(
                        address['city'] as String,
                        style: TextStyle(color: AppColors.greyDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address['phone'] as String,
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
