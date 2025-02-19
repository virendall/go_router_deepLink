import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/car_provider.dart';

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cars')),
      body: Consumer<CarProvider>(
        builder: (context, carProvider, child) {
          return ListView.builder(
            itemCount: carProvider.cars.length,
            itemBuilder: (context, index) {
              final car = carProvider.cars[index];
              return ListTile(
                title: Text(car.name),
                subtitle: Text('\$${car.price.toStringAsFixed(2)}'),
                onTap: () => context.go('/car/${car.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
