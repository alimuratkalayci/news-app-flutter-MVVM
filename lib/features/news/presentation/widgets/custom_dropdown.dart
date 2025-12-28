import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: DropdownButton<String>(
              iconSize: AppDimensions.iconSizeMedium,
              iconEnabledColor: AppColors.textPrimary,
              isExpanded: true,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                    ),
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: AppColors.surface,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

