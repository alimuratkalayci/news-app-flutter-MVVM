import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_dimensions.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({
    super.key,
    this.message = 'No news found',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: const BoxDecoration(
                color: AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLarge),
            Text(
              message,
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            const Text(
              'Try changing the country or category',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

