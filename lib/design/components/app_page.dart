// lib/design/components/app_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/services/services.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.child,
    this.title,
    this.showBackButton = false,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.padding,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showExitConfirmation = true,
  });

  final Widget child;
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showExitConfirmation;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !showBackButton,
      // TODO: NOT WORKING AT ALL!!!
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) _handleBackPressed(context);
      },
      child: AppPlatform.scaffold(
        backgroundColor: backgroundColor ?? context.colors.background,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Padding(
            padding: padding ?? EdgeInsets.all(Design.spacing.screenPadding),
            child: child,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.surface,
      foregroundColor: context.colors.textPrimary,
      elevation: 0,
      leading: showBackButton
          ? AppButton(
              type: ButtonType.icon,
              icon: Design.icons.backArrow,
              onPressed: onBackPressed ?? () => _handleBackPressed(context),
            )
          : null,
      title: title != null ? Text(title!, style: context.typo.headline4) : null,
      actions: actions,
    );
  }

  void _handleBackPressed(BuildContext context) {
    final storage = Get.find<StorageService>();
    final stack = storage.getRouteStack();

    if (stack.length > 1) {
      stack.removeLast();
      storage.saveRouteStack(stack);
      Get.offAllNamed(stack.last);
    } else {
      _showExitDialog(context);
    }
  }
}

Future<bool> _showExitDialog(BuildContext context) async {
  return await AppDialog.exit(context);
}
