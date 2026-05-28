import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/maintenance_item.dart';
import '../repositories/maintenance_repository.dart';
import 'auth_provider.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) => MaintenanceRepository());

final maintenanceProvider = StreamProvider.autoDispose<List<MaintenanceItem>>((ref) {
  final user = ref.watch(currentUserProvider);
  final repository = ref.watch(maintenanceRepositoryProvider);
  if (user == null) {
    return const Stream.empty();
  }
  return repository.watchMaintenance(user.uid);
});

final reminderTitleProvider = StateProvider<String>((ref) => 'Oil Change');
final reminderIntervalProvider = StateProvider<int>((ref) => 90);
