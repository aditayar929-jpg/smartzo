import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../theme/app_colors.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  final List<BannerItem> _banners = [
    BannerItem(
      title: 'Summer Sale',
      subtitle: 'Up to 50% Off',
      color: AppColors.primary,
      icon: Icons.local_offer,
    ),
    BannerItem(
      title: 'New Arrivals',
      subtitle: 'Check out latest products',
      color: AppColors.accent,
      icon: Icons.new_releases,
    ),
    BannerItem(
      title: 'Free Delivery',
      subtitle: 'On orders above ₹499',
      color: const Color(0xFF4CAF50),
      icon: Icons.local_shipping,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = _banners[index];
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [banner.color, banner.color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 20,
                    top: 20,
                    bottom: 20,
                    child: Icon(
                      banner.icon,
                      size: 80,
                      color: AppColors.white.withOpacity(0.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner.subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Shop Now',
                            style: TextStyle(
                              color: banner.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primary
                    : AppColors.greyLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}
