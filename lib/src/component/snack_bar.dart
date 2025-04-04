import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;

  const CustomSnackBar({
    super.key,
    required this.message,
    this.backgroundColor = Colors.red,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient background dan bayangan lembut
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, String message,
      {Color backgroundColor = Colors.red,
      IconData icon = Icons.error_outline}) {
    final snackBar = SnackBar(
      content: CustomSnackBar(
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          Colors.transparent, // supaya background container terlihat
      elevation: 0,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
