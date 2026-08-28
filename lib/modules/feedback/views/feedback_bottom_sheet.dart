// lib/modules/feedback/views/feedback_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/design/design.dart';
import '../controllers/feedback.controller.dart';

class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const FeedbackBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());

    return Container(
      padding: EdgeInsets.only(
        left: Design.spacing.lg,
        right: Design.spacing.lg,
        top: Design.spacing.xl,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + Design.spacing.xxl,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Design.spacing.radiusXLarge),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reusable Handle Bar
            const AppHandleBar(),
            SizedBox(height: Design.spacing.lg),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Share Feedback',
                  style: context.typo.headline3.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Design.icons.close,
                      color: context.colors.textSecondary),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: Design.spacing.md),

            // Rating Slider Bar (1 to 10)
            Obx(
              () => AppRatingSlider(
                value: controller.rating.value.toDouble(),
                onChanged: (val) => controller.setRating(val.round()),
                label: 'How was your experience?',
              ),
            ),
            SizedBox(height: Design.spacing.lg),

            // Feedback input field
            AppInputField(
              label: 'Your Thoughts',
              hint: 'Tell us anything — bugs, suggestions, or ideas...',
              controller: controller.textController,
              maxLines: 4,
              minLines: 3,
              onChanged: (_) {},
            ),
            SizedBox(height: Design.spacing.xl),

            // Submit Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: controller.isSubmitting.value
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        text: 'Send Feedback',
                        onPressed: () => controller.submitFeedback(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
