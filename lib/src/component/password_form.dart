import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme/index_style.dart';

class PasswordForm extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextStyle textStyle;
  final TextStyle labelStyle;
  final TextStyle errorTextStyle;

  const PasswordForm({
    super.key,
    required this.label,
    this.controller,
    this.hintText = '',
    this.textStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    this.labelStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    this.errorTextStyle = const TextStyle(color: Colors.red, fontSize: 12),
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
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
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConstants.backgroundSecondary,
                border: Border.all(
                  color: ColorConstants.greyColorsecondary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      obscureText: !isPasswordVisible,
                      style: TypographyStyle.bodyMedium
                          .copyWith(color: ColorConstants.blackColorPrimary),
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
                color: ColorConstants.backgroundSecondary,
                child: Text(
                  widget.label,
                  style: TypographyStyle.bodyMedium
                      .copyWith(color: ColorConstants.greyColorPrimary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
