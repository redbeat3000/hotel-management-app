class Sale {
  final String id;
  final String itemName;
  final int quantity;
  final double price;
  final bool isDelivery;
  final DateTime timestamp;

  Sale({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.isDelivery,
    required this.timestamp,
  });

  double get total => quantity * price;
}
