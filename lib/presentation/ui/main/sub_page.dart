import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';

class SubPage extends HookConsumerWidget {
  final Widget child;

  const SubPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('conduit'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () {
            final router = ref.watch(AppNavigation.provider).router;
            if (router.canPop()) {
              router.pop();
            }
          },
        ),
      ),
      body: child,
    );
  }
}
