import 'package:flutter/material.dart';
import '../config/theme/index_style.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final bool isLoading;
  final bool enabled;
  final int debounceTime; // waktu dalam milidetik

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.height,
    required this.width,
    this.isLoading = false,
    this.enabled = true,
    this.debounceTime = 1000, // default 1 detik
  });

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton> {
  bool isPressed = false;
  DateTime? _lastPressedTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastPressedTime != null &&
        now.difference(_lastPressedTime!).inMilliseconds <
            widget.debounceTime) {
      return;
    }
    _lastPressedTime = now;

    if (widget.enabled && !widget.isLoading) {
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: widget.enabled && !widget.isLoading
          ? (_) => setState(() => isPressed = true)
          : null,
      onTapUp: widget.enabled && !widget.isLoading
          ? (_) => setState(() => isPressed = false)
          : null,
      onTapCancel: widget.enabled && !widget.isLoading
          ? () => setState(() => isPressed = false)
          : null,
      child: AnimatedContainer(
        height: widget.height,
        width: widget.width,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: _getButtonColor(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: widget.isLoading
              ? const CircularProgressIndicator(
                  semanticsLabel: 'Loading...',
                  semanticsValue: 'Loading...',
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  widget.label,
                  style: TypographyStyle.bodySemiBold
                      .copyWith(color: ColorConstants.backgroundColor),
                ),
        ),
      ),
    );
  }

  Color _getButtonColor() {
    if (!widget.enabled || widget.isLoading) {
      return ColorConstants.greyColorPrimary;
    }
    return isPressed
        ? ColorConstants.greyColorPrimary
        : ColorConstants.purpleColor;
  }
}
