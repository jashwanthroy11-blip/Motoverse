import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bike.dart';
import '../repositories/bike_repository.dart';

final bikeRepositoryProvider = Provider<BikeRepository>((ref) => BikeRepository());

final bikeListProvider = StreamProvider<List<Bike>>((ref) {
  final repository = ref.watch(bikeRepositoryProvider);
  return repository.watchBikes();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final categoryFilterProvider = StateProvider<String>((ref) => 'All');

final filteredBikeProvider = Provider<List<Bike>>((ref) {
  final bikes = ref.watch(bikeListProvider).value ?? [];
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(categoryFilterProvider);

  return bikes.where((bike) {
    final matchesCategory = category == 'All' || bike.category == category;
    final matchesQuery = bike.name.toLowerCase().contains(query) ||
        bike.company.toLowerCase().contains(query) ||
        bike.category.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});
