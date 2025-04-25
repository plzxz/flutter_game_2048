import 'package:flutter/material.dart';

class ShopTabs extends StatelessWidget {
  final int selectedTab;
  final void Function(int) onTabSelected;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;

  const ShopTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 50),
        _buildTab("Item", 0),
        const SizedBox(width: 10),
        _buildTab("Theme", 1),
      ],
    );
  }

  //สร้างเเท็บไอเทม กับ ธีม
  Widget _buildTab(String label, int index) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: () => onTabSelected(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedTab == index ? activeColor : inactiveColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, color: textColor),
        ),
      ),
    );
  }
}
