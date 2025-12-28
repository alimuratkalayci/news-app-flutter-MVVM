import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/news_model.dart';
import '../widgets/gradient_app_bar.dart' show ModernAppBar;

class NewsDetailPage extends StatelessWidget {
  final ArticleModel article;

  const NewsDetailPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ModernAppBar(title: 'Article'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 280,
                  color: AppColors.divider,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: 280,
                  color: AppColors.divider,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textTertiary,
                    size: 64,
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall,
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

                  const SizedBox(height: AppDimensions.spacingLarge),

                  // Title
                  Text(
                    article.title,
                    style: AppTextStyles.heading1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.spacingMedium),

                  // Author
                  if (article.author != null && article.author!.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppDimensions.paddingSmall),
                        Expanded(
                          child: Text(
                            article.author!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingLarge),
                  ],

                  // Description
                  if (article.description != null && article.description!.isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: AppDimensions.spacingLarge),
                  ],

                  // Divider
                  const Divider(color: AppColors.border),

                  const SizedBox(height: AppDimensions.spacingLarge),

                  // Content
                  if (article.content != null && article.content!.isNotEmpty) ...[
                    Text(
                      article.content!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.7,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: AppDimensions.spacingLarge),
                  ],

                  // Read More Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(article.url),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Read Full Article'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

