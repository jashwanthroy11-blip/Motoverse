import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile', style: TextStyle(color: AppColors.textHigh, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Manage your account, notifications, and preferences.', style: TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.5)),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.displayName ?? 'Guest Rider', style: const TextStyle(color: AppColors.textHigh, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(user?.email ?? 'Not signed in', style: const TextStyle(color: AppColors.textMedium)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _InfoChip(label: 'Saved builds', value: '0'),
                      const SizedBox(width: 12),
                      _InfoChip(label: 'Wishlist', value: '0'),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceAlt, foregroundColor: AppColors.textHigh),
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: AppColors.textHigh, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
