import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/pages/payment/components/plan_card.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: Constants.locale.payment.tr,
      showBackButton: true,
      child: Center(
        child: SizedBox(
          child: Column(
            children: [
              Text(
                Constants.locale.planSubtitle.tr,
                style: context.typo.headline4,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.sm),
              Text(
                Constants.locale.planDescription.tr,
                style: context.typo.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.xl),
              Expanded(child: Obx(() => _buildBody(context))),
              Obx(
                () => AppButton(
                  text: Constants.locale.subscribe.tr,
                  isExpanded: true,
                  onPressed:
                      controller.selectedPlan != null &&
                          !controller.isSubscribing.value
                      ? () => controller.subscribe(context)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.error.value != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.error.value!,
              style: context.typo.bodyMedium.copyWith(
                color: context.colors.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Design.spacing.lg),
            AppButton(
              text: Constants.locale.retry.tr,
              onPressed: controller.fetchPlans,
              type: ButtonTypeEnum.secondary,
            ),
          ],
        ),
      );
    }

    if (controller.plans.isEmpty && controller.isLoading.value) {
      return const SizedBox.shrink();
    }

    if (controller.plans.isEmpty) {
      return Center(
        child: Text(
          Constants.locale.noPlans.tr,
          style: context.typo.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.plans.length,
      itemBuilder: (context, index) {
        final plan = controller.plans[index];
        return Obx(
          () => PlanCard(
            name: plan.name,
            description: plan.description,
            price: plan.price,
            periodLabel: plan.periodLabel,
            isSelected: controller.selectedPlanId.value == plan.id,
            onTap: () => controller.selectPlan(plan.id),
          ),
        );
      },
    );
  }
}
