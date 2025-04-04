import '../config/theme/index_style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton> {
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
              ? ColorConstants.greyColorPrimary
              : ColorConstants.purpleColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TypographyStyle.bodySemiBold
                .copyWith(color: ColorConstants.backgroundColor),
          ),
        ),
      ),
    );
  }
}
