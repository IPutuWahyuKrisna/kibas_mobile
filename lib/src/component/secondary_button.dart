import 'package:flutter/material.dart';
import '../config/theme/index_style.dart';

class SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double borderRadius;
  final double height;
  final double width;
  final TextStyle textStyle;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.height,
    required this.width,
    this.borderRadius = 8.0,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  });

  @override
  // ignore: library_private_types_in_public_api
  _SecondaryButtonState createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        height: widget.height, // Menggunakan widget.height
        width: widget.width, // Menggunakan widget.width
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
            color: isPressed
                ? ColorConstants.greyColorsecondary
                : ColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: ColorConstants.greyColorsecondary,
              width: 1,
            )),
        child: Center(
          child: Text(
            widget.label,
            style: TypographyStyle.bodyMedium
                .copyWith(color: ColorConstants.blackColorPrimary),
          ),
        ),
      ),
    );
  }
}
