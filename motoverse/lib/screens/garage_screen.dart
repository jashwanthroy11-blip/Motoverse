import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../models/customization_build.dart';
import '../providers/garage_provider.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildsAsync = ref.watch(garageBuildsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Garage', style: TextStyle(color: AppColors.textHigh, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Your saved bikes and most recent builds are kept here.', style: TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.5)),
            const SizedBox(height: 22),
            Expanded(
              child: buildsAsync.when(
                data: (builds) => builds.isEmpty
                    ? const Center(child: Text('No saved builds yet. Customize a ride to save it here.', style: TextStyle(color: AppColors.textMedium)))
                    : ListView.separated(
                        itemCount: builds.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) => _GarageCard(buildItem: builds[index]),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Center(child: Text('Failed to load saved builds.', style: TextStyle(color: AppColors.error))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GarageCard extends StatelessWidget {
  final CustomizationBuild buildItem;

  const _GarageCard({required this.buildItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            buildItem.primaryImageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(buildItem.primaryImageUrl, width: 100, height: 100, fit: BoxFit.cover),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.bike_scooter, color: AppColors.textMuted, size: 44),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(buildItem.buildName, style: const TextStyle(color: AppColors.textHigh, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(buildItem.bikeName, style: const TextStyle(color: AppColors.textMedium)),
                  const SizedBox(height: 10),
                  Text('Accessories: ${buildItem.selectedAccessoryIds.length}', style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                ],
              ),
            ),
            Text('₹${buildItem.totalPrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
