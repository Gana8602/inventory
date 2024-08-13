import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? fieldTitle;
  final String? hintText;
  final TextEditingController textEditingController;
  final double? height;
  final TextInputType? keyboard;
  final List<TextInputFormatter>? textInput;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Color? color;
  final bool obscureText;

  const CustomTextField(
      {super.key,
      this.hintText,
      required this.textEditingController,
      this.fieldTitle,
      this.height,
      this.keyboard,
      this.textInput,
      this.onTap,
      this.color,
      this.obscureText = false,
      this.suffixIcon});

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
            fieldTitle!,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: TextField(
            onTap: onTap,
            controller: textEditingController,
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  // borderSide: BorderSide.none
                  borderSide:
                      BorderSide(color: color ?? Colors.grey.withOpacity(0.1))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.lightBlue),
              ),
            ),
            keyboardType: keyboard,
            inputFormatters: textInput,
          ),
        ),
      ],
    );
  }
}
