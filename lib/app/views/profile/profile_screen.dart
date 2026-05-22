import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final user = authController.user.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.white,
                      child: Text(
                        user != null
                            ? '${user.firstName[0]}${user.lastName[0]}'
                            : 'U',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.white),
                      onPressed: () => Get.toNamed(AppRoutes.editProfile),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              _buildMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                onTap: () => Get.toNamed(AppRoutes.orders),
              ),
              _buildMenuItem(
                icon: Icons.favorite_outline,
                title: 'Wishlist',
                onTap: () => Get.toNamed(AppRoutes.wishlist),
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Addresses',
                onTap: () => Get.toNamed(AppRoutes.address),
              ),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () => Get.toNamed(AppRoutes.notifications),
              ),
              _buildMenuItem(
                icon: Icons.local_offer_outlined,
                title: 'Coupons',
                onTap: () => Get.toNamed(AppRoutes.coupons),
              ),
              _buildMenuItem(
                icon: Icons.headset_mic_outlined,
                title: 'Customer Support',
                onTap: () => Get.toNamed(AppRoutes.customerSupport),
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () => Get.toNamed(AppRoutes.settings),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                color: AppColors.error,
                onTap: () => _showLogoutDialog(context, authController),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color ?? AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: color ?? AppColors.grey,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
