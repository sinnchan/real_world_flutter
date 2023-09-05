import 'package:flutter/material.dart';
import 'package:real_world_flutter/main.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final loadingWidgets = [
      ColoredBox(
        color: AppColors.grey.withOpacity(0.5),
      ),
      const Center(
        child: CircularProgressIndicator(),
      ),
    ];

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        child,
        if (isLoading) ...loadingWidgets,
      ],
    );
  }
}
