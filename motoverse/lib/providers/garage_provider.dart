import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customization_build.dart';
import '../repositories/garage_repository.dart';
import 'auth_provider.dart';

final garageRepositoryProvider = Provider<GarageRepository>((ref) => GarageRepository());

final garageBuildsProvider = StreamProvider.autoDispose<List<CustomizationBuild>>((ref) {
  final user = ref.watch(currentUserProvider);
  final repository = ref.watch(garageRepositoryProvider);
  if (user == null) {
    return const Stream.empty();
  }
  return repository.watchGarageBuilds(user.uid);
});
