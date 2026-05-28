import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_router.dart';
import 'customization_screen.dart';
import '../models/bike.dart';

class BikeDetailArguments {
  final Bike bike;

  BikeDetailArguments(this.bike);
}

class BikeDetailScreen extends StatelessWidget {
  final BikeDetailArguments arguments;

  const BikeDetailScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final bike = arguments.bike;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(bike.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: bike.imageUrl ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 240,
                placeholder: (context, url) => const SizedBox(height: 240, child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Container(
                  height: 240,
                  color: AppColors.surfaceAlt,
                  child: const Center(child: Icon(Icons.bike_scooter, color: Colors.white30, size: 80)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(bike.company.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, letterSpacing: 1.6)),
            const SizedBox(height: 8),
            Text(bike.name, style: const TextStyle(color: AppColors.textHigh, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Text(bike.description, style: const TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.6)),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatTile(label: 'Top speed', value: bike.topSpeed),
                _StatTile(label: 'Range', value: bike.range),
                _StatTile(label: 'Power', value: bike.power),
              ],
            ),
            const SizedBox(height: 24),
            Text('Starting at ${bike.startingPrice}', style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.customization,
                  arguments: CustomizationScreenArguments(bike),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Customize this ride'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: AppColors.textHigh, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
