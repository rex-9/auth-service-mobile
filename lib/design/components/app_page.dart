// lib/design/components/app_page.dart
import 'package:flutter/cupertino.dart';
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

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: !showBackButton,
      // // TODO: NOT WORKING AT ALL!!!
      // onPopInvokedWithResult: (bool didPop, dynamic result) async {
      //   if (!didPop) _handleBackPressed(context);
      // },
      child: osScaffold(
        backgroundColor: backgroundColor ?? context.colors.background,
        appBar: (isIOS) ? _buildIosAppBar(context) : _buildAndroidAppBar(context),
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

  PreferredSizeWidget _buildAndroidAppBar(BuildContext context) {
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

  PreferredSizeWidget _buildIosAppBar(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: context.colors.surface,
      leading: showBackButton
          ? AppButton(
              type: ButtonType.icon,
              icon: Design.icons.backArrow,
              onPressed: onBackPressed ?? () => _handleBackPressed(context),
            )
          : null,
      middle: title != null
          ? Text(
              title!,
              style: context.typo.headline4.copyWith(
                color: context.colors.textPrimary,
              ),
            )
          : null,
      trailing: actions != null && actions!.isNotEmpty
          ? IconTheme(
              data: IconThemeData(color: context.colors.textPrimary),
              child: DefaultTextStyle(
                style: TextStyle(color: context.colors.textPrimary),
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1,
                  child: Row(

                      mainAxisSize: MainAxisSize.min, children: actions!),
                ),
              ),
            )
          : null,
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

  static Widget osScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Color? backgroundColor,
    bool resizeToAvoidBottomInset = true,
  }) {
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar as CupertinoNavigationBar?,
        backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
        child: Material(
          child: SafeArea(
            child: Stack(
              children: [
                body,
                if (bottomNavigationBar != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: bottomNavigationBar,
                  ),
                if (floatingActionButton != null)
                  Positioned(bottom: 80, right: 20, child: floatingActionButton),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor ?? Colors.white,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) async {
  return await AppDialog.exit(context);
}
