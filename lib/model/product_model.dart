class Product {
  final String id;
  final String name;
  final String serialNo;
  final String modelNo;
  final String category;
  final String type;
  final String itemRemarks;
  final String quantity;
  final String vendorName;
  final String barCode;
  final String stockInOut;
  final String price;

  Product({
    required this.id,
    required this.name,
    required this.serialNo,
    required this.modelNo,
    required this.category,
    required this.type,
    required this.itemRemarks,
    required this.quantity,
    required this.vendorName,
    required this.barCode,
    required this.stockInOut,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      serialNo: json['serial_no'],
      modelNo: json['model_no'],
      category: json['category'],
      type: json['type'],
      itemRemarks: json['item_remarks'],
      quantity: json['qty'].toString(),
      vendorName: json['vendor_name'],
      barCode: json['barcode'],
      stockInOut: json['Stock_in_out'],
      price: json['price'],
    );
  }
}
