import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/page/main/main_notifier.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(mainPageNotifier);
    final notifier = ref.watch(mainPageNotifier.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('conduit'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sell,
              color: AppColors.white,
            ),
            onPressed: () {
              // TODO
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('articles list'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.selectedTabIndex,
        onTap: notifier.onSelectNavigationItem,
        items: const [
          BottomNavigationBarItem(
            label: 'Articles',
            icon: Icon(Icons.article),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
