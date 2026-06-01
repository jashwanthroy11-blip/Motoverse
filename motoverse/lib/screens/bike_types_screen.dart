import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class BikeTypesScreen extends StatelessWidget {
  const BikeTypesScreen({super.key});

  static const bikeTypes = [
    {
      'title': 'Sports Bikes',
      'subtitle':
          'Lightweight machines built for speed, agility and performance.',
    },
    {
      'title': 'Cruisers',
      'subtitle':
          'Comfort-focused bikes designed for relaxed long-distance rides.',
    },
    {
      'title': 'Adventure Bikes',
      'subtitle':
          'Versatile motorcycles made for both road and off-road touring.',
    },
    {
      'title': 'Scooters',
      'subtitle':
          'Easy-to-ride, city-friendly bikes with automatic transmissions.',
    },
    {
      'title': 'Touring Bikes',
      'subtitle':
          'Premium bikes with storage and comfort for long highway journeys.',
    },
    {
      'title': 'Naked Bikes',
      'subtitle':
          'Minimalist street bikes with upright ergonomics and exposed styling.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Types'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textHigh,
      ),
      backgroundColor: AppColors.background,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: bikeTypes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final type = bikeTypes[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type['title']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHigh,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  type['subtitle']!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textMedium,
                    height: 1.5,
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
