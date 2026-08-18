// lib/pages/payment_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/payment.controller.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/models/models.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Plans & Pricing',
      showBackButton: true,
      child: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Choose Your Plan',
                  style: context.typo.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Design.spacing.xs),
                Text(
                  'Select the option that works best for you',
                  style: context.typo.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Design.spacing.xxl),

                // Products List
                if (controller.products.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(Design.spacing.xl),
                      child: Text(
                        'No products available right now.',
                        style: context.typo.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...controller.products.map(
                    (product) =>
                        _buildProductCard(context, controller, product),
                  ),

                // Transactions History
                if (controller.transactions.isNotEmpty) ...[
                  SizedBox(height: Design.spacing.xxxl),
                  Text('Order History', style: context.typo.headline3),
                  SizedBox(height: Design.spacing.md),
                  ...controller.transactions.map(
                    (tx) => _buildTransactionTile(context, tx),
                  ),
                ],
                SizedBox(height: Design.spacing.xxxl),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    PaymentController controller,
    ProductModel product,
  ) {
    final activeSub = controller.getActiveSubscription(product.id);
    final canceledSub = controller.getCanceledSubscription(product.id);
    final fullyCanceledSub = controller.getFullyCanceledSubscription(
      product.id,
    );
    final purchaseCount = controller.getPurchaseCount(product.id);

    return AppCard(
      margin: EdgeInsets.only(bottom: Design.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(product.name, style: context.typo.headline3),
              ),
              if (activeSub != null)
                AppBadge(
                  text: 'Active',
                  type: BadgeType.success,
                  icon: Design.icons.activeSubscription,
                )
              else if (canceledSub != null)
                AppBadge(
                  text: 'Expiring',
                  type: BadgeType.warning,
                  icon: Design.icons.scheduledCancel,
                )
              else if (fullyCanceledSub != null)
                AppBadge(
                  text: 'Ended',
                  type: BadgeType.error,
                  icon: Design.icons.canceledSubscription,
                ),
            ],
          ),
          SizedBox(height: Design.spacing.xs),
          Text(product.description, style: context.typo.bodyMedium),
          SizedBox(height: Design.spacing.lg),

          // Pricing
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                product.price,
                style: context.typo.headline1.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: Design.spacing.xs),
              Text(
                product.recurring ? '/ ${product.periodLabel}' : ' (one-time)',
                style: context.typo.bodySmall,
              ),
            ],
          ),
          SizedBox(height: Design.spacing.xl),

          // Actions
          _buildActionButtons(
            context,
            controller,
            product,
            activeSub,
            canceledSub,
            fullyCanceledSub,
            purchaseCount,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    PaymentController controller,
    ProductModel product,
    SubscriptionModel? activeSub,
    SubscriptionModel? canceledSub,
    SubscriptionModel? fullyCanceledSub,
    int purchaseCount,
  ) {
    // 1. Active subscription -> Cancel button
    if (activeSub != null) {
      final periodEnd = activeSub.currentPeriodEnd != null
          ? activeSub.currentPeriodEnd!.split('T').first
          : 'end of period';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Renews automatically on $periodEnd',
            style: context.typo.caption,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Design.spacing.md),
          AppButton(
            type: ButtonType.secondary,
            text: 'Cancel Subscription',
            onPressed: () async {
              final ok = await AppDialog.confirm(
                context: context,
                title: Constants.locale.cancelSubTitle.tr,
                message: Constants.locale.cancelSubConfirmMsg.tr,
                confirmLabel: Constants.locale.cancelSubTitle.tr,
              );
              if (ok) controller.cancelSubscription(activeSub.id);
            },
          ),
        ],
      );
    }

    // 2. Canceled (pending end of cycle) -> Resume button
    if (canceledSub != null) {
      final periodEnd = canceledSub.currentPeriodEnd != null
          ? canceledSub.currentPeriodEnd!.split('T').first
          : 'end of period';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Access remains active until $periodEnd',
            style: context.typo.caption.copyWith(
              color: Design.colors.warningDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Design.spacing.md),
          AppButton(
            type: ButtonType.secondary,
            text: 'Resume Subscription',
            onPressed: () => controller.resumeSubscription(canceledSub.id),
          ),
        ],
      );
    }

    // 3. Fully canceled / ended -> Subscribe again
    if (fullyCanceledSub != null) {
      return AppButton(
        text: 'Subscribe Again',
        onPressed: () => controller.startCheckout(product.id),
      );
    }

    // 4. One-time purchase product
    if (!product.recurring && purchaseCount > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            text: 'Buy Again',
            onPressed: () => controller.startCheckout(product.id),
          ),
          SizedBox(height: Design.spacing.xs),
          Text(
            'Purchased $purchaseCount time${purchaseCount > 1 ? "s" : ""}',
            style: context.typo.caption,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // 5. Default Subscribe / Buy button
    return AppButton(
      text: product.recurring ? 'Subscribe Now' : 'Buy Now',
      onPressed: () => controller.startCheckout(product.id),
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel tx) {
    return AppCard(
      margin: EdgeInsets.only(bottom: Design.spacing.sm),
      padding: EdgeInsets.symmetric(
        horizontal: Design.spacing.md,
        vertical: Design.spacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tx.productName ?? 'Payment', style: context.typo.bodyLarge),
              if (tx.createdAt != null)
                Text(
                  tx.createdAt!.split('T').first,
                  style: context.typo.caption,
                ),
            ],
          ),
          AppBadge(
            text: tx.paid ? 'Paid' : tx.status,
            type: tx.paid ? BadgeType.success : BadgeType.warning,
          ),
        ],
      ),
    );
  }
}
