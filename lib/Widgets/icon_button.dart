import 'package:flutter/material.dart';

class IconTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final String tooltip;
  final Color iconColor;
  final Color hoverIconColor;
  final Color textColor;
  final Color hoverTextColor;

  IconTextButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.tooltip = '',
    this.iconColor = Colors.black,
    this.hoverIconColor = Colors.blue,
    this.textColor = Colors.black,
    this.hoverTextColor = Colors.blue,
  });

  @override
  _IconTextButtonState createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip,
        child: TextButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(
            widget.icon,
            color: isHovered ? widget.hoverIconColor : widget.iconColor,
          ),
          label: Text(
            widget.label,
            style: TextStyle(
              color: isHovered ? widget.hoverTextColor : widget.textColor,
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              isHovered ? widget.hoverIconColor : widget.iconColor,
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(
                color: isHovered ? widget.hoverTextColor : widget.textColor,
              ),
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
