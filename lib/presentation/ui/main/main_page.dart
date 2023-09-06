import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/infrastructure/api/real_world_api.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/main/main_notifier.dart';

class MainPage extends HookConsumerWidget {
  final Widget child;

  const MainPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(MainPageNotifier.provider);

    final notifier = ref.watch(MainPageNotifier.provider.notifier);

    final tagButton = IconButton(
      icon: const Icon(
        Icons.sell,
        color: AppColors.white,
      ),
      onPressed: () async {},
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('conduit'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: vm.isShowTagButton ? [tagButton] : null,
      ),
      body: child,
      floatingActionButton: vm.isShowActionButton
          ? FloatingActionButton(
              child: const Icon(Icons.edit),
              onPressed: () async {
                final api = ref.watch(RealWorldApi.provider);
                final result = await api.getArticles();
                pLogger.d(result.toJson());
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.selectedTabIndex,
        onTap: notifier.onSelectNavigationItem,
        items: [
          const BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          const BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
          if (vm.isShowSettingBottomTab)
            const BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
        ],
      ),
    );
  }
}
