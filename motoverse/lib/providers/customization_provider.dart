import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/accessory.dart';
import '../repositories/customization_repository.dart';

final selectedAccessoriesProvider = StateProvider<List<Accessory>>((ref) => []);

final customizationRepositoryProvider = Provider<CustomizationRepository>((ref) => CustomizationRepository());

final customizationTotalProvider = Provider<double>((ref) {
  final accessories = ref.watch(selectedAccessoriesProvider);
  return accessories.fold(0.0, (sum, item) => sum + item.price);
});

final customizationSummaryProvider = Provider<String>((ref) {
  final total = ref.watch(customizationTotalProvider);
  return 'Total add-ons: ${ref.watch(selectedAccessoriesProvider).length} • +₹${total.toStringAsFixed(0)}';
});
