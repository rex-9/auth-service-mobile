import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveHelper{

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 760;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1280 &&
          MediaQuery.of(context).size.width >= 760;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1280;

  static bool isUltraHD(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1450;

  static bool isScalingHeight(BuildContext context) {
    return MediaQuery.of(context).size.height <= 600;
  }

  static bool isMobileBrowser(context) {
    return kIsWeb && isMobile(context);
  }

}



// class ResponsiveLayout extends StatelessWidget {
//   final Widget mobile;
//   final Widget? tablet;
//   final Widget desktop;
//
//   const ResponsiveLayout({
//     Key? key,
//     required this.mobile,
//     this.tablet,
//     required this.desktop,
//   }) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }
