import 'bike.dart';

class BikeData {
  static const categories = [
    'All',
    'Sports',
    'Cruiser',
    'Adventure',
    'Scooters',
  ];

  static const List<Bike> sampleBikes = [
    Bike(
      id: 'ktm-duke-390',
      name: 'KTM Duke 390',
      company: 'KTM',
      category: 'Sports',
      description: 'A lightweight streetfighter with razor-sharp handling and aggressive style.',
      startingPrice: '₹2.65 Lakh',
      basePrice: 265000,
      rating: 4.8,
      topSpeed: '170 km/h',
      range: '300 km',
      power: '43 HP',
      imageUrl:
          'https://images.unsplash.com/photo-1520947655129-1e2357bf92ec?auto=format&fit=crop&w=900&q=80',
    ),
    Bike(
      id: 'royal-enfield-classic-350',
      name: 'Royal Enfield Classic 350',
      company: 'Royal Enfield',
      category: 'Cruiser',
      description: 'Timeless cruiser with a vintage soul, tuned for comfortable long rides.',
      startingPrice: '₹2.10 Lakh',
      basePrice: 210000,
      rating: 4.5,
      topSpeed: '120 km/h',
      range: '260 km',
      power: '19.1 HP',
      imageUrl:
          'https://images.unsplash.com/photo-1513601111271-cc6656f39e1a?auto=format&fit=crop&w=900&q=80',
    ),
    Bike(
      id: 'yamaha-r15-v4',
      name: 'Yamaha R15 V4',
      company: 'Yamaha',
      category: 'Sports',
      description: 'Track-inspired performance with aerodynamic sharp lines and responsive power.',
      startingPrice: '₹1.84 Lakh',
      basePrice: 184000,
      rating: 4.7,
      topSpeed: '140 km/h',
      range: '270 km',
      power: '18.4 HP',
      imageUrl:
          'https://images.unsplash.com/photo-1511285560929-44ed3c27048c?auto=format&fit=crop&w=900&q=80',
    ),
    Bike(
      id: 'himalayan-411',
      name: 'Royal Enfield Himalayan',
      company: 'Royal Enfield',
      category: 'Adventure',
      description: 'A rugged adventure bike tuned for trails, mountains, and long scenic journeys.',
      startingPrice: '₹2.15 Lakh',
      basePrice: 215000,
      rating: 4.6,
      topSpeed: '130 km/h',
      range: '450 km',
      power: '24.3 HP',
      imageUrl:
          'https://images.unsplash.com/photo-1515722719562-705e17b4d3fe?auto=format&fit=crop&w=900&q=80',
    ),
    Bike(
      id: 'tvs-apache-rtr-310',
      name: 'TVS Apache RTR 310',
      company: 'TVS',
      category: 'Sports',
      description: 'A sharp performance machine engineered for the street and the circuit.',
      startingPrice: '₹2.61 Lakh',
      basePrice: 261000,
      rating: 4.4,
      topSpeed: '155 km/h',
      range: '330 km',
      power: '34.5 HP',
      imageUrl:
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?auto=format&fit=crop&w=900&q=80',
    ),
    Bike(
      id: 'honda-activa-6g',
      name: 'Honda Activa 6G',
      company: 'Honda',
      category: 'Scooters',
      description: 'A smooth and dependable city scooter with efficient everyday performance.',
      startingPrice: '₹84,900',
      basePrice: 84900,
      rating: 4.2,
      topSpeed: '65 km/h',
      range: '85 km',
      power: '5.5 HP',
      imageUrl:
          'https://images.unsplash.com/photo-1520876252824-5f5a8f0b7f41?auto=format&fit=crop&w=900&q=80',
    ),
  ];
}
