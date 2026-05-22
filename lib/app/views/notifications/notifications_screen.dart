import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Order Shipped!',
        'body': 'Your order #1234 has been shipped and is on its way.',
        'time': '2 hours ago',
        'icon': Icons.local_shipping,
        'color': AppColors.info,
      },
      {
        'title': 'Special Offer',
        'body': 'Get 20% off on all electronics. Use code: SAVE20',
        'time': '5 hours ago',
        'icon': Icons.local_offer,
        'color': AppColors.accent,
      },
      {
        'title': 'Order Delivered',
        'body': 'Your order #1230 has been delivered successfully.',
        'time': '1 day ago',
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
      {
        'title': 'New Arrivals',
        'body': 'Check out the latest products in our store!',
        'time': '2 days ago',
        'icon': Icons.new_releases,
        'color': AppColors.primary,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 100, color: AppColors.greyLight),
                  const SizedBox(height: 24),
                  const Text(
                    'No notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (notification['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          notification['icon'] as IconData,
                          color: notification['color'] as Color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification['body'] as String,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notification['time'] as String,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
