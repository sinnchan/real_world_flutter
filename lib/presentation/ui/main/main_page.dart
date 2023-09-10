import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/main/main_notifier.dart';
import 'package:real_world_flutter/presentation/ui/main/main_view_model.dart';

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

    _ifNeedShowTabDialog(context, notifier, vm);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('conduit'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          if (vm.isShowTagButton)
            IconButton(
              onPressed: notifier.onTapOpenTag,
              icon: const Icon(
                Icons.sell,
                color: AppColors.white,
              ),
            ),
        ],
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

  void _ifNeedShowTabDialog(
    BuildContext context,
    MainPageNotifier notifier,
    MainViewModel vm,
  ) {
    useEffect(
      () {
        if (vm.tags.isEmpty) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => _dialogWidget(vm, notifier, context),
          );
        });
        return null;
      },
      [vm.tags],
    );
  }

  SimpleDialog _dialogWidget(
    MainViewModel vm,
    MainPageNotifier notifier,
    BuildContext context,
  ) {
    return SimpleDialog(
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 6,
                runSpacing: 6,
                children: _tags(vm, notifier, context).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Iterable<InkWell> _tags(
    MainViewModel vm,
    MainPageNotifier notifier,
    BuildContext context,
  ) {
    return vm.tags.map((e) {
      return InkWell(
        onTap: () {
          notifier.onTapTag(e);
          context.pop();
        },
        borderRadius: BorderRadius.circular(15),
        splashColor: AppColors.main,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Text(
            e,
            style: const TextStyle(color: AppColors.grey),
          ),
        ),
      );
    });
  }
}
