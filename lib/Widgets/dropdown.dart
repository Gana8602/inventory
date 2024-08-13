// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String fieldTitle;
  final String label;
  final String val;
  List<String> items;
  void Function(String?)? onChanged;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;

  CustomDropDown(
      {super.key,
      required this.items,
      required this.val,
      required this.onChanged,
      this.width,
      this.height,
      this.color,
      this.borderColor,
      this.label = '',
      this.fieldTitle = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 4.0),
          child: Text(
            fieldTitle,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: color ?? Colors.grey.withOpacity(0.1),
          ),
          child: DropdownButtonFormField<String>(
              value: val,
              items: items.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // borderSide: BorderSide.none
                      borderSide: BorderSide(
                          color: borderColor ?? Colors.grey.withOpacity(0.1))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                  labelText: label),
              onChanged: onChanged),
        ),
      ],
    );
  }
}
