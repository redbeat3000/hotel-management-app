class DeliveryModel {
  final int? id;
  final String item;
  final int quantity;
  final double price;
  final double total;
  final String paymentType; // M-Pesa or Cash
  final int staffId; // linked to staff
  final double commission;
  final String date;

  DeliveryModel({
    this.id,
    required this.item,
    required this.quantity,
    required this.price,
    required this.total,
    required this.paymentType,
    required this.staffId,
    required this.commission,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'quantity': quantity,
      'price': price,
      'total': total,
      'paymentType': paymentType,
      'staffId': staffId,
      'commission': commission,
      'date': date,
    };
  }

  factory DeliveryModel.fromMap(Map<String, dynamic> map) {
    return DeliveryModel(
      id: map['id'],
      item: map['item'],
      quantity: map['quantity'],
      price: map['price'],
      total: map['total'],
      paymentType: map['paymentType'],
      staffId: map['staffId'],
      commission: map['commission'],
      date: map['date'],
    );
  }
}
