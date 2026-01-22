import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class FilterChipWidget extends StatelessWidget {

  const FilterChipWidget({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
}