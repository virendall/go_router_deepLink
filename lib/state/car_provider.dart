import 'package:flutter/material.dart';
import 'package:go_router_deep_link/model/car.dart';

class CarProvider extends ChangeNotifier {
  final List<Car> _cars = [
    Car(
      id: 1,
      name: 'Tesla Model 3',
      description: 'Electric Sedan',
      price: 35000,
    ),
    Car(
      id: 2,
      name: 'Toyota Camry',
      description: 'Reliable Sedan',
      price: 25000,
    ),
    Car(id: 3, name: 'Honda CR-V', description: 'Popular SUV', price: 28000),
  ];

  List<Car> get cars => _cars;

  Car? getCarById(int id) {
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (e) {
      return null;
    }
  }
}
