import 'package:flutter/material.dart';
import 'package:inventory/Constants/style.dart';

class RevenueInfo extends StatelessWidget {
  const RevenueInfo({super.key, required this.title, required this.amount});

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "$title \n\n",
                  style: TextStyle(color: lightGray, fontSize: 16)),
              TextSpan(
                  text: "₹ $amount",
                  style: TextStyle(
                      color: dark, fontSize: 24, fontWeight: FontWeight.bold)),
            ])));
  }
}
