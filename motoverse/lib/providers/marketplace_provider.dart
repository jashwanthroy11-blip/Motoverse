import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/accessory.dart';
import '../repositories/marketplace_repository.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) => MarketplaceRepository());

final accessoriesProvider = StreamProvider<List<Accessory>>((ref) {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return repository.watchAccessories();
});

final cartItemsProvider = StateProvider<List<Accessory>>((ref) => []);
final wishlistProvider = StateProvider<List<Accessory>>((ref) => []);
