class Trash {
  final String id;
  final String name;
  final String serialNo;
  final String modelNo;
  final String mainCategory;
  final String category;
  final String location;
  final String type;
  final String qty;
  final String price;
  final String totalPrice;
  final String itemremarks;
  final String projectName;
  final String projectNo;
  final String purchaseOrder;
  final String invoiceNo;
  final String vendorName;
  final String date;
  final String place;
  final String mos;
  final String recieverName;
  final String vendorRemarks;
  final String stockInOut;
  final String barcode;

  Trash({
    required this.id,
    required this.name,
    required this.serialNo,
    required this.modelNo,
    required this.mainCategory,
    required this.category,
    required this.location,
    required this.type,
    required this.qty,
    required this.price,
    required this.totalPrice,
    required this.itemremarks,
    required this.projectName,
    required this.projectNo,
    required this.purchaseOrder,
    required this.invoiceNo,
    required this.vendorName,
    required this.date,
    required this.place,
    required this.mos,
    required this.recieverName,
    required this.vendorRemarks,
    required this.stockInOut,
    required this.barcode,
  });

  factory Trash.fromjson(Map<String, dynamic> j) {
    return Trash(
      id: j['id'],
      name: j['name'],
      serialNo: j['serial_no'],
      modelNo: j['model_no'],
      mainCategory: j['main_category'],
      category: j['category'],
      location: j['location'],
      type: j['type'],
      qty: j['qty'],
      price: j['price'],
      totalPrice: j['total_price'],
      itemremarks: j['item_remarks'],
      projectName: j['project_name'],
      projectNo: j['project_no'],
      purchaseOrder: j['purchase_order'],
      invoiceNo: j['invoice_no'],
      vendorName: j['vendor_name'],
      date: j['date'],
      place: j['place'],
      mos: j['mos'],
      recieverName: j['receiver_name'],
      vendorRemarks: j['vendor_remarks'],
      stockInOut: j['Stock_in_out'],
      barcode: j['barcode'],
    );
  }
}
