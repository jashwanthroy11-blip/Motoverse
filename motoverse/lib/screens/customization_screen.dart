import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../models/accessory.dart';
import '../models/bike.dart';
import '../models/customization_build.dart';
import '../providers/auth_provider.dart';
import '../providers/customization_provider.dart';
import '../providers/garage_provider.dart';
import '../providers/marketplace_provider.dart';

class CustomizationScreenArguments {
  final Bike bike;

  CustomizationScreenArguments(this.bike);
}

class CustomizationScreen extends ConsumerStatefulWidget {
  final CustomizationScreenArguments arguments;

  const CustomizationScreen({super.key, required this.arguments});

  @override
  ConsumerState<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends ConsumerState<CustomizationScreen> {
  bool _saving = false;

  Future<void> _saveBuild() async {
    final user = ref.read(currentUserProvider);
    final accessories = ref.read(selectedAccessoriesProvider);
    if (user == null) return;

    setState(() => _saving = true);
    final totalPrice = accessorizedPrice(widget.arguments.bike.basePrice, accessories);
    final build = CustomizationBuild(
      id: '',
      userId: user.uid,
      bikeId: widget.arguments.bike.id,
      bikeName: widget.arguments.bike.name,
      primaryImageUrl: widget.arguments.bike.imageUrl ?? '',
      selectedAccessoryIds: accessories.map((e) => e.id).toList(),
      totalPrice: totalPrice,
      createdAt: Timestamp.now(),
      buildName: '${widget.arguments.bike.name} Build',
    );

    try {
      await ref.read(customizationRepositoryProvider).saveBuild(build);
      await ref.read(garageRepositoryProvider).saveBuildToGarage(build);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Build saved to garage successfully.')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      setState(() => _saving = false);
    }
  }

  double accessorizedPrice(double base, List<Accessory> accessories) {
    return base + accessories.fold(0.0, (total, item) => total + item.price);
  }

  @override
  Widget build(BuildContext context) {
    final bike = widget.arguments.bike;
    final accessoriesAsync = ref.watch(accessoriesProvider);
    final selectedAccessories = ref.watch(selectedAccessoriesProvider);
    final customizationTotal = ref.watch(customizationTotalProvider);
    final currentPrice = bike.basePrice + customizationTotal;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.surface, title: const Text('Customize Ride')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${bike.name} customization', style: const TextStyle(color: AppColors.textHigh, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: bike.imageUrl ?? '',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(width: 110, height: 110, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Container(
                      width: 110,
                      height: 110,
                      color: AppColors.surfaceAlt,
                      child: const Icon(Icons.bike_scooter, color: AppColors.textMuted, size: 54),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Base price', style: TextStyle(color: AppColors.textMedium)),
                      const SizedBox(height: 6),
                      Text('₹${bike.basePrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.accent, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('Current total', style: TextStyle(color: AppColors.textMedium)),
                      const SizedBox(height: 6),
                      Text('₹${currentPrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.textHigh, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text('Accessories', style: TextStyle(color: AppColors.textHigh, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            accessoriesAsync.when(
              data: (items) => Column(
                children: items.map((accessory) {
                  final selected = selectedAccessories.any((item) => item.id == accessory.id);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                    tileColor: AppColors.surfaceAlt,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: Icon(selected ? Icons.check_circle : Icons.add_circle_outline, color: AppColors.accent),
                    title: Text(accessory.name, style: const TextStyle(color: AppColors.textHigh, fontWeight: FontWeight.bold)),
                    subtitle: Text(accessory.description, style: const TextStyle(color: AppColors.textMedium)),
                    trailing: Text('₹${accessory.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    onTap: () {
                      final notifier = ref.read(selectedAccessoriesProvider.notifier);
                      if (selected) {
                        notifier.state = notifier.state.where((item) => item.id != accessory.id).toList();
                      } else {
                        notifier.state = [...notifier.state, accessory];
                      }
                    },
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Unable to load accessories.', style: TextStyle(color: AppColors.error))),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _saveBuild,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Save Build • +₹${customizationTotal.toStringAsFixed(0)}'),
            ),
          ],
        ),
      ),
    );
  }
}
