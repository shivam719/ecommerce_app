import 'package:flutter/material.dart';

/// CategoryChip represents an interactive filter chip for selecting product categories.
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primary,
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
        ),
        elevation: isSelected ? 2 : 0,
        pressElevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: 1,
          ),
        ),
      ),
    );
  }
}
