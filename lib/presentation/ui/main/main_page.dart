import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('conduit'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: child,
      floatingActionButton: vm.isShowActionButton
          ? FloatingActionButton(
              onPressed: notifier.onTapEditButton,
              child: const Icon(Icons.edit),
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
