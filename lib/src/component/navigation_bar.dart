import 'package:flutter/material.dart';
import '../config/theme/index_style.dart';
import 'package:iconsax/iconsax.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: ColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Iconsax.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onDestinationSelected(0),
              ),
              _NavBarItem(
                icon: Iconsax.activity,
                label: 'Activity',
                isSelected: selectedIndex == 1,
                onTap: () => onDestinationSelected(1),
              ),
              _ScanButton(
                onTap: () => onDestinationSelected(2),
                isSelected: selectedIndex == 2,
              ),
              _NavBarItem(
                icon: Iconsax.document,
                label: 'Report',
                isSelected: selectedIndex == 3,
                onTap: () => onDestinationSelected(3),
              ),
              _NavBarItem(
                icon: Iconsax.user_square,
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: () => onDestinationSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // decoration: BoxDecoration(
        //   color: isSelected
        //       ? Theme.of(context).primaryColor.withOpacity(0.1)
        //       : Colors.transparent,
        //   borderRadius: BorderRadius.circular(50),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? ColorConstants.purpleColor
                  : ColorConstants.greyColorsecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TypographyStyle.captionsReguler.copyWith(
                color: isSelected
                    ? ColorConstants.purpleColor
                    : ColorConstants.greyColorsecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const _ScanButton({
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: ColorConstants.purpleColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Iconsax.scan_barcode4,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
