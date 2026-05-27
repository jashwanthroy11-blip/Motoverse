import 'package:flutter/material.dart';

import '../models/bike.dart';
import '../services/auth_service.dart';
import '../services/bike_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Bike> _fallbackBikes = [
    const Bike(
      id: 'fallback-1',
      name: 'Rogue Comet',
      category: 'Sport Cruiser',
      description: 'A bold ride with high responsiveness and refined style.',
      topSpeed: '240 km/h',
      range: '320 km',
      power: '150 HP',
      imageUrl: null,
      createdAt: null,
    ),
    const Bike(
      id: 'fallback-2',
      name: 'Nocturne X',
      category: 'Urban Tracker',
      description: 'Street-ready agility with adaptive customization modes.',
      topSpeed: '210 km/h',
      range: '280 km',
      power: '135 HP',
      imageUrl: null,
      createdAt: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final repository = BikeRepository();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('MotoVerse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: StreamBuilder<List<Bike>>(
        stream: repository.bikesStream(),
        builder: (context, snapshot) {
          final bikes = snapshot.data ?? _fallbackBikes;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Bike fleet',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Manage bikes, review modifications, and upload new images to Firebase Storage.',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final bike = bikes[index];
                    return BikeCard(bike: bike);
                  }, childCount: bikes.length),
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 32)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final sampleBike = Bike(
            id: '',
            name: 'Volt Phantom',
            category: 'Electric Racer',
            description:
                'Silent power, instant torque, and premium neon highlights.',
            topSpeed: '225 km/h',
            range: '380 km',
            power: '160 HP',
            imageUrl: null,
            createdAt: null,
          );
          await repository.addBike(sampleBike);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sample bike added to Firebase.')),
            );
          }
        },
        label: const Text('Add sample bike'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class BikeCard extends StatelessWidget {
  final Bike bike;

  const BikeCard({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF111827),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike.category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF94A3AF),
                          fontSize: 12,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bike.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (bike.imageUrl != null)
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                        image: NetworkImage(bike.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.bike_scooter,
                    size: 84,
                    color: Color(0xFF6366F1),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              bike.description,
              style: const TextStyle(color: Color(0xFF9CA3AF), height: 1.6),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _AttributeBadge(label: bike.topSpeed, icon: Icons.speed),
                const SizedBox(width: 10),
                _AttributeBadge(label: bike.range, icon: Icons.bolt),
                const Spacer(),
                Text(
                  bike.power,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttributeBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AttributeBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
