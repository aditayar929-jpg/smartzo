import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = StorageService.isDarkMode();
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.location_on_outlined,
            title: 'Manage Addresses',
            onTap: () {},
          ),

          const Divider(),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.dark_mode, color: AppColors.primary),
            ),
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              StorageService.setDarkMode(value);
              // TODO: Implement theme change
            },
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            ),
            title: const Text('Push Notifications'),
            value: _notifications,
            onChanged: (value) {
              setState(() => _notifications = value);
            },
            activeColor: AppColors.primary,
          ),

          const Divider(),

          // Support Section
          _buildSectionHeader('Support'),
          _buildSettingsTile(
            icon: Icons.headset_mic_outlined,
            title: 'Customer Support',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About Smartzo',
            onTap: () => _showAboutDialog(),
          ),

          const Divider(),

          // Danger Zone
          _buildSectionHeader('Danger Zone'),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () => _showDeleteAccountDialog(),
          ),

          const SizedBox(height: 24),

          // App Version
          Center(
            child: Text(
              'Smartzo v1.0.0',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Smartzo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Smartzo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Smartzo is a modern eCommerce app built with Flutter and WooCommerce backend.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Delete account
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
