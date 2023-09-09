import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/articles_list.dart';
import 'package:real_world_flutter/presentation/ui/feeds/organisms/feeds_tab/feeds_state_notifier.dart';
import 'package:real_world_flutter/presentation/ui/common/molecules/loading_overlay.dart';
import 'package:real_world_flutter/presentation/ui/feeds/organisms/feeds_tab/feeds_view_model.dart';

class FeedsListTabs extends StatefulHookConsumerWidget {
  const FeedsListTabs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FeedsListState();
  }
}

class _FeedsListState extends ConsumerState<FeedsListTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  FeedsViewModel get _vm {
    return ref.watch(FeedsStateNotifier.provider);
  }

  @override
  Widget build(BuildContext context) {
    _setupTabController();

    return LoadingOverlay(
      isLoading: _vm.isLoading,
      child: Column(
        children: [
          if (_vm.tabs.length > 1)
            TabBar(
              controller: _tabController,
              tabs: _vm.tabs.map((e) => _buildTab(e.name)).toList(),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _vm.tabs
                  .map((e) => ArticlesList(dataSource: e.dataSource))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _setupTabController() {
    useEffect(
      () {
        _tabController = TabController(
          length: _vm.tabs.length,
          vsync: this,
        );
        return null;
      },
      [_vm.tabs.length],
    );
  }

  SizedBox _buildTab(String tabName) {
    return SizedBox(
      height: 58,
      child: Center(
        child: Text(tabName),
      ),
    );
  }
}
