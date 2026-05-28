import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../models/accessory.dart';
import '../providers/marketplace_provider.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessoriesAsync = ref.watch(accessoriesProvider);
    final cartItems = ref.watch(cartItemsProvider);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Marketplace', style: TextStyle(color: AppColors.textHigh, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Browse accessories and build your perfect kit.', style: TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.5)),
            const SizedBox(height: 20),
            Row(
              children: [
                _Badge(label: 'Cart', value: cartItems.length),
                const SizedBox(width: 12),
                _Badge(label: 'Wishlist', value: wishlist.length),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: accessoriesAsync.when(
                data: (items) => ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final inCart = cartItems.any((it) => it.id == item.id);
                    final inWish = wishlist.any((it) => it.id == item.id);
                    return _AccessoryTile(
                      accessory: item,
                      inCart: inCart,
                      inWish: inWish,
                      onCartTap: () {
                        final notifier = ref.read(cartItemsProvider.notifier);
                        notifier.state = inCart ? notifier.state.where((i) => i.id != item.id).toList() : [...notifier.state, item];
                      },
                      onWishTap: () {
                        final notifier = ref.read(wishlistProvider.notifier);
                        notifier.state = inWish ? notifier.state.where((i) => i.id != item.id).toList() : [...notifier.state, item];
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Center(child: Text('Marketplace unavailable.', style: TextStyle(color: AppColors.error))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final int value;

  const _Badge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMedium)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
            child: Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _AccessoryTile extends StatelessWidget {
  final Accessory accessory;
  final bool inCart;
  final bool inWish;
  final VoidCallback onCartTap;
  final VoidCallback onWishTap;

  const _AccessoryTile({
    required this.accessory,
    required this.inCart,
    required this.inWish,
    required this.onCartTap,
    required this.onWishTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(accessory.name, style: const TextStyle(color: AppColors.textHigh, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(accessory.type, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                const SizedBox(height: 8),
                Text(accessory.description, style: const TextStyle(color: AppColors.textMedium, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${accessory.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              IconButton(onPressed: onCartTap, icon: Icon(inCart ? Icons.shopping_cart : Icons.add_shopping_cart, color: AppColors.accent)),
              IconButton(onPressed: onWishTap, icon: Icon(inWish ? Icons.favorite : Icons.favorite_border, color: AppColors.error)),
            ],
          ),
        ],
      ),
    );
  }
}
