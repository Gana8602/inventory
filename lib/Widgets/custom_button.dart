import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double height;
  final double width;
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color textColor;
  final Color borderColor;
  final Color hoverColor;
  final double textSize;
  final BorderRadius borderRadius;

  const CustomButton({
    super.key,
    this.onTap,
    this.height = 50.0,
    this.width = 200.0,
    this.icon = Icons.person,
    this.iconColor = Colors.black,
    this.text = 'Add Text',
    this.textSize = 20,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.hoverColor = Colors.lightBlue,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              border: Border.all(
                color: isHovered ? widget.hoverColor : widget.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: isHovered ? widget.hoverColor : widget.iconColor,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: isHovered ? widget.hoverColor : widget.textColor,
                    fontSize: widget.textSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
  }
}
