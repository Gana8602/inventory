import 'package:flutter/material.dart';
import 'package:inventory/Constants/style.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key,
      required this.title,
      required this.value,
      this.topcolor,
      this.textColor,
      this.isActive = false,
      required this.onTap});

  final String title;
  final String value;
  final Color? topcolor;
  final Color? textColor;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        height: 136,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  color: topcolor ?? active,
                  height: 5,
                )),
              ],
            ),
            Expanded(child: Container()),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "$title\n",
                      style: TextStyle(
                          fontSize: 16, color: isActive ? active : lightGray)),
                  TextSpan(
                      text: value,
                      style: TextStyle(
                          fontSize: 40, color: isActive ? dark : textColor)),
                ])),
            Expanded(child: Container()),
          ],
        ),
      ),
    ));
  }
}
