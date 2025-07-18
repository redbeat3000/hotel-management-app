class SaleModel {
  final int? id;
  final String item;
  final int quantity;
  final double price;
  final bool isDelivery;
  final int? staffId; // NEW
  final String timestamp;

  SaleModel({
    this.id,
    required this.item,
    required this.quantity,
    required this.price,
    required this.isDelivery,
    this.staffId, // NEW
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'quantity': quantity,
      'price': price,
      'isDelivery': isDelivery ? 1 : 0,
      'staffId': staffId, // NEW
      'timestamp': timestamp,
    };
  }

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'],
      item: map['item'],
      quantity: map['quantity'],
      price: map['price'],
      isDelivery: map['isDelivery'] == 1,
      staffId: map['staffId'], // NEW
      timestamp: map['timestamp'],
    );
  }
}
