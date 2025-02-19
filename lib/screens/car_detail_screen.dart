import 'package:flutter/material.dart';
import 'package:go_router_deep_link/state/car_provider.dart';
import 'package:provider/provider.dart';

class CarDetailScreen extends StatelessWidget {
  final int carId;

  const CarDetailScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (context, carProvider, child) {
        final car = carProvider.getCarById(carId);

        if (car == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Car Not Found')),
            body: const Center(child: Text('Car not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(car.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${car.name}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('Description: ${car.description}'),
                const SizedBox(height: 8),
                Text('Price: \$${car.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
