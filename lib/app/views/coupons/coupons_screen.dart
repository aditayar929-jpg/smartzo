import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coupons = [
      {
        'code': 'WELCOME20',
        'discount': '20% OFF',
        'description': 'Get 20% off on your first order',
        'minOrder': 'Min order: ₹499',
        'expiry': 'Expires: 31 Dec 2026',
      },
      {
        'code': 'SAVE50',
        'discount': '₹50 OFF',
        'description': 'Flat ₹50 off on orders above ₹299',
        'minOrder': 'Min order: ₹299',
        'expiry': 'Expires: 15 Jun 2026',
      },
      {
        'code': 'FREESHIP',
        'discount': 'Free Shipping',
        'description': 'Get free delivery on all orders',
        'minOrder': 'No minimum order',
        'expiry': 'Expires: 30 Jun 2026',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Coupons & Offers')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coupon['discount']!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coupon['description']!,
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          coupon['code']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.grey),
                      const SizedBox(width: 8),
                      Text(
                        coupon['minOrder']!,
                        style: TextStyle(color: AppColors.grey),
                      ),
                      const Spacer(),
                      Text(
                        coupon['expiry']!,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: coupon['code']!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coupon code copied!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.copy, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Copy Code',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
