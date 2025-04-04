import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme/index_style.dart';

class PasswordFormSmall extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextStyle labelStyle;
  final TextStyle errorTextStyle;

  const PasswordFormSmall({
    super.key,
    required this.label,
    this.controller,
    this.hintText = '',
    this.labelStyle = const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
    this.errorTextStyle = const TextStyle(color: Colors.red, fontSize: 12),
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFormSmallState createState() => _PasswordFormSmallState();
}

class _PasswordFormSmallState extends State<PasswordFormSmall> {
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConstants.backgroundColor,
                border: Border.all(
                  color: ColorConstants.greyColorPrimary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      obscureText: !isPasswordVisible,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        errorStyle: const TextStyle(
                          height: 0, // Hilangkan error bawaan
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              top: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: ColorConstants.backgroundColor,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
