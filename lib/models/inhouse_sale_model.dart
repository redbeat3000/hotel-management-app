class InhouseSaleModel {
  final int? id;
  final String item;
  final int quantity;
  final double unitPrice;
  final String date;

  InhouseSaleModel({
    this.id,
    required this.item,
    required this.quantity,
    required this.unitPrice,
    required this.date,
  });

  double get total => quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'date': date,
    };
  }

  factory InhouseSaleModel.fromMap(Map<String, dynamic> map) {
    return InhouseSaleModel(
      id: map['id'],
      item: map['item'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      date: map['date'],
    );
  }
}
