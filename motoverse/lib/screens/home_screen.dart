import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/routes/app_router.dart';
import 'bike_detail_screen.dart';
import '../models/accessory.dart';
import '../providers/bike_provider.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/bike_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const categories = [
    'All',
    'Sports',
    'Cruiser',
    'Adventure',
    'Scooters',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bikes = ref.watch(filteredBikeProvider);
    final accessoriesAsync = ref.watch(accessoriesProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.homeHeadline,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textHigh,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.homeSubhead,
              style: TextStyle(
                color: AppColors.textMedium,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              style: const TextStyle(color: AppColors.textHigh),
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                ),
                hintText: 'Search bikes, companies or categories',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.bikeTypes);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'View bike types',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final label = categories[index];
                  final selected = label == selectedCategory;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) =>
                        ref.read(categoryFilterProvider.notifier).state = label,
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.surfaceAlt,
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.textHigh
                          : AppColors.textMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Featured bikes',
              style: TextStyle(
                color: AppColors.textHigh,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: bikes.isEmpty
                  ? const Center(
                      child: Text(
                        'No bikes match your search yet.',
                        style: TextStyle(color: AppColors.textMedium),
                      ),
                    )
                  : ListView.separated(
                      itemCount: bikes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final bike = bikes[index];
                        return BikeCard(
                          bike: bike,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.bikeDetail,
                              arguments: BikeDetailArguments(bike),
                            );
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Trending modifications',
              style: TextStyle(
                color: AppColors.textHigh,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            accessoriesAsync.when(
              data: (items) => SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      _TrendingAccessoryCard(item: items[index]),
                ),
              ),
              loading: () => const SizedBox(
                height: 110,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox(
                height: 110,
                child: Center(
                  child: Text(
                    'Failed to load accessories',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingAccessoryCard extends StatelessWidget {
  final Accessory item;

  const _TrendingAccessoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              color: AppColors.textHigh,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.type,
            style: const TextStyle(color: AppColors.textMedium, fontSize: 13),
          ),
          const Spacer(),
          Text(
            '₹${item.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
