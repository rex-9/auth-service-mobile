// lib/design/components/app_network_banner.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../locales/app_locales.dart';
import '../../services/network.service.dart';
import '../design.dart';

/// Global overlay banner displaying offline / connectivity restored status.
/// When offline: displays error banner ('Connection lost').
/// When back online: displays green success banner ('Connection is safe and sound') for 3s, then smoothly disappears.
class AppNetworkBanner extends StatelessWidget {
  final Widget child;

  const AppNetworkBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          if (!Get.isRegistered<NetworkService>()) {
            return const SizedBox.shrink();
          }

          final network = Get.find<NetworkService>();
          final isVisible = network.isBannerVisible.value;
          final isRestored = network.isRestored.value;
          final contentColor = isRestored
              ? context.colors.onSuccess
              : context.colors.onError;

          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !isVisible,
              child: AnimatedSlide(
                duration: Design.timers.medium,
                curve: Design.timers.easeInOut,
                offset: isVisible ? Offset.zero : const Offset(0, -1.2),
                child: AnimatedOpacity(
                  duration: Design.timers.short,
                  opacity: isVisible ? 1.0 : 0.0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Design.spacing.md,
                        vertical: Design.spacing.xs,
                      ),
                      child: AnimatedContainer(
                        duration: Design.timers.medium,
                        curve: Design.timers.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: Design.spacing.md,
                          vertical: Design.spacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isRestored
                              ? context.colors.success
                              : context.colors.error,
                          borderRadius: BorderRadius.circular(
                            Design.spacing.radiusXLarge,
                          ),
                          boxShadow: Design.colors.shadows.md,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isRestored
                                  ? Design.icons.wifi
                                  : Design.icons.wifiOff,
                              color: contentColor,
                              size: Design.spacing.iconMedium,
                            ),
                            SizedBox(width: Design.spacing.sm),
                            Flexible(
                              child: Text(
                                isRestored
                                    ? AppLocales.common.connectionRestored.tr
                                    : AppLocales.common.connectionLost.tr,
                                style: context.typo.labelMedium.copyWith(
                                  color: contentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
