// ignore_for_file: avoid_print

class StockOutRecord {
  // final int id;
  final String name;
  final String serialNo;
  final String modelNo;
  final String category;
  final String qty;
  final double price;
  final double totalPrice;
  final String stock;
  final DateTime date;

  StockOutRecord({
    // required this.id,
    required this.name,
    required this.serialNo,
    required this.modelNo,
    required this.category,
    required this.qty,
    required this.price,
    required this.totalPrice,
    required this.stock,
    required this.date,
  });

  factory StockOutRecord.fromJson(Map<String, dynamic> json) {
    try {
      // print(json); // Log the JSON data

      return StockOutRecord(
        // id: json['id'],
        name: json['name'],
        serialNo: json['serial_no'],
        modelNo: json['model_no'],
        category: json['category'],
        qty: (json['qty']), // Convert to int
        price: double.parse(json['price'].toString()), // Ensure double type
        totalPrice:
            double.parse(json['total_price'].toString()), // Ensure double type

        stock: json['stock'],
        date: DateTime.parse(json['date']), // Convert to DateTime
      );
    } catch (e) {
      print('Error parsing StockOutRecord: $e');
      rethrow;
    }
  }
}
