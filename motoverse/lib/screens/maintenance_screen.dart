import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../models/maintenance_item.dart';
import '../providers/maintenance_provider.dart';
import '../providers/auth_provider.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  bool _saving = false;

  Future<void> _addReminder() async {
    final user = ref.read(currentUserProvider);
    final title = ref.read(reminderTitleProvider);
    final interval = ref.read(reminderIntervalProvider);
    if (user == null) return;

    setState(() => _saving = true);
    try {
      final nextDue = DateTime.now().add(Duration(days: interval));
      final item = MaintenanceItem(
        id: '',
        userId: user.uid,
        title: title,
        description: 'Scheduled maintenance reminder for $title.',
        nextDue: nextDue,
        intervalDays: interval,
        completed: false,
      );
      await ref.read(maintenanceRepositoryProvider).addReminder(item);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder added to your maintenance tracker.')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maintenanceAsync = ref.watch(maintenanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Maintenance', style: TextStyle(color: AppColors.textHigh, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Track oil changes, services, and next due reminders.', style: TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.5)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => ref.read(reminderTitleProvider.notifier).state = value,
                    style: const TextStyle(color: AppColors.textHigh),
                    decoration: const InputDecoration(labelText: 'Reminder title', labelStyle: TextStyle(color: AppColors.textMedium)),
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 120,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => ref.read(reminderIntervalProvider.notifier).state = int.tryParse(value) ?? 90,
                    style: const TextStyle(color: AppColors.textHigh),
                    decoration: const InputDecoration(labelText: 'Days', labelStyle: TextStyle(color: AppColors.textMedium)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _addReminder,
              child: _saving ? const CircularProgressIndicator(color: Colors.white) : const Text('Add reminder'),
            ),
            const SizedBox(height: 26),
            const Text('Upcoming service reminders', style: TextStyle(color: AppColors.textHigh, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: maintenanceAsync.when(
                data: (items) => items.isEmpty
                    ? const Center(child: Text('No reminders yet. Add one to get service notifications.', style: TextStyle(color: AppColors.textMedium)))
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) => _MaintenanceTile(item: items[index]),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Center(child: Text('Unable to load maintenance reminders.', style: TextStyle(color: AppColors.error))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceTile extends StatelessWidget {
  final MaintenanceItem item;

  const _MaintenanceTile({required this.item});

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
                Text(item.title, style: const TextStyle(color: AppColors.textHigh, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(item.description, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                const SizedBox(height: 8),
                Text('Next due • ${item.nextDue.toLocal().toString().split(' ')[0]}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Checkbox(value: item.completed, onChanged: (_) {}),
        ],
      ),
    );
  }
}
