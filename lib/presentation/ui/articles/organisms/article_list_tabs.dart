import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/articles_list.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/articles_state_notifier.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/articles_view_model.dart';
import 'package:real_world_flutter/presentation/ui/common/molecules/loading_overlay.dart';

class ArticleListTabs extends StatefulHookConsumerWidget {
  const ArticleListTabs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ArticleListState();
  }
}

class _ArticleListState extends ConsumerState<ArticleListTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  ArticlesOrganizmViewModel get _vm {
    return ref.watch(ArticlesStateNotifier.provider);
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
