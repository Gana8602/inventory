import 'dart:convert';

class BoxModel {
  final String id;
  final String billNo;
  final String poNo;
  final String date;
  final String supplierName;
  final String remark;
  final String recieverName;
  final String status;
  final String token;
  final List<Produc> products;

  BoxModel(
      {required this.id,
      required this.billNo,
      required this.date,
      required this.poNo,
      required this.supplierName,
      required this.remark,
      required this.recieverName,
      required this.status,
      required this.token,
      required this.products});

  factory BoxModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productList = jsonDecode(json['products']);
    return BoxModel(
      id: json['id'],
      billNo: json['billNo'],
      date: json['date'],
      poNo: json['poNo'],
      supplierName: json['supplierName'],
      remark: json['remark'],
      recieverName: json['recieverName'],
      status: json['status'],
      token: json['token'],
      products: List<Produc>.from(productList.map((e) => Produc.fromJson(e))),
    );
  }
}

class Produc {
  final String name;
  final String qty;

  Produc({
    required this.name,
    required this.qty,
  });

  factory Produc.fromJson(Map<String, dynamic> j) {
    return Produc(name: j['name'] ?? "", qty: j['qty'] ?? '0');
  }
}
