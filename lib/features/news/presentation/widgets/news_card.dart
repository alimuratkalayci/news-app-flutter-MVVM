import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppDimensions.spacingMedium,
        left: AppDimensions.paddingMedium,
        right: AppDimensions.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.overlay,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.cardBorderRadius),
                    topRight: Radius.circular(AppDimensions.cardBorderRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 200,
                      color: AppColors.divider,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 200,
                      color: AppColors.divider,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textTertiary,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              
              // Content Section
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and Date Row
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingSmall,
                              vertical: AppDimensions.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            ),
                            child: Text(
                              article.source.name,
                              style: AppTextStyles.cardSource.copyWith(
                                color: AppColors.secondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingSmall),
                        Text(
                          _formatDate(article.publishedAt),
                          style: AppTextStyles.cardSource,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingSmall),
                    
                    // Title
                    Text(
                      article.title,
                      style: AppTextStyles.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (article.description != null && article.description!.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.spacingSmall),
                      Text(
                        article.description!,
                        style: AppTextStyles.cardDescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    if (article.author != null && article.author!.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.spacingSmall),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppDimensions.paddingXS),
                          Expanded(
                            child: Text(
                              article.author!,
                              style: AppTextStyles.cardSource,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}

