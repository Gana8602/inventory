import 'package:flutter/material.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Widgets/custom_text.dart';

class InfoCardSmall extends StatelessWidget {
  const InfoCardSmall(
      {super.key,
      required this.title,
      required this.value,
      this.textColor,
      this.isActive = false,
      required this.onTap});

  final String title;
  final String value;
  final Color? textColor;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 6),
                    color: lightGray.withOpacity(.1),
                    blurRadius: 12),
              ],
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: isActive ? active : lightGray, width: .5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                size: 24,
                weight: FontWeight.w300,
                color: isActive ? active : lightGray,
              ),
              CustomText(
                text: value,
                size: 24,
                weight: FontWeight.w300,
                color: isActive ? active : dark,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
