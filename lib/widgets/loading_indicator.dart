// lib/design/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Design.colors.primary),
    );
  }
}
