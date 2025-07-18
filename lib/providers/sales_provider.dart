import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sale.dart';
import 'package:uuid/uuid.dart';

final salesProvider = StateNotifierProvider<SalesNotifier, List<Sale>>((ref) {
  return SalesNotifier();
});

class SalesNotifier extends StateNotifier<List<Sale>> {
  SalesNotifier() : super([]);

  final uuid = const Uuid();

  void addSale(String itemName, int quantity, double price, bool isDelivery) {
    final sale = Sale(
      id: uuid.v4(),
      itemName: itemName,
      quantity: quantity,
      price: price,
      isDelivery: isDelivery,
      timestamp: DateTime.now(),
    );
    state = [...state, sale];
  }

  void clearSales() {
    state = [];
  }
}
