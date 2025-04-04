import 'package:flutter/material.dart';

import '../config/theme/index_style.dart';

class BasicForm extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextStyle textStyle;
  final TextStyle errorTextStyle;
  final TextInputType inputType;

  const BasicForm({
    super.key,
    required this.label,
    required this.inputType,
    this.controller,
    this.hintText = '',
    this.textStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    this.errorTextStyle = const TextStyle(color: Colors.red, fontSize: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 3.5),
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConstants.backgroundSecondary,
                border: Border.all(
                  color: ColorConstants.greyColorsecondary,
                  width: 1,
                ),
              ),
              child: TextFormField(
                keyboardType: inputType,
                controller: controller,
                style: textStyle,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  errorStyle: const TextStyle(
                    height: 0, // Sembunyikan error style bawaan
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: ColorConstants.backgroundSecondary,
                child: Text(
                  label,
                  style: textStyle.copyWith(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
