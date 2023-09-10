import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kotlin_scope_function/kotlin_scope_function.dart';
import 'package:real_world_flutter/domain/model/profile.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/articles_list.dart';
import 'package:real_world_flutter/presentation/ui/common/color/ext_color.dart';
import 'package:real_world_flutter/presentation/ui/profile/molecules/shared/profile_follow_button.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/profile_contents_notifier.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/profile_info.dart';

class ProfileContents extends HookConsumerWidget {
  final _loading = const Center(child: CircularProgressIndicator());
  final String? username;

  const ProfileContents({
    super.key,
    this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ProfileNotifier.provider(username);
    final vm = ref.watch(provider);
    final myDataSource = vm.myArticlesDataSource;
    final favDataSource = vm.favoritesArticlesDataSource;

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _userInfo(vm.profile),
            _tabs(),
          ];
        },
        body: _tabBarViews(myDataSource, favDataSource),
      ),
    );
  }

  TabBarView _tabBarViews(
    ArticlesDataSource? myDataSource,
    ArticlesDataSource? favDataSource,
  ) {
    return TabBarView(
      children: [
        myDataSource == null
            ? _loading
            : ArticlesList(dataSource: myDataSource),
        favDataSource == null
            ? _loading
            : ArticlesList(dataSource: favDataSource),
      ],
    );
  }

  SliverPersistentHeader _tabs() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverPersistentHeaderDelegate(
        TabBar(
          tabs: [
            _tab('My Articles'),
            _tab('Favorited Articles'),
          ],
        ),
      ),
    );
  }

  SliverList _userInfo(Profile? profile) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            color: AppColors.lightGray.withLight(0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileInfo(profile: profile),
                Align(
                  alignment: Alignment.centerRight,
                  child: profile?.let((it) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 30, bottom: 10),
                      child: ProfileFollowButton(username: it.username),
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String tabName) {
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(tabName),
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  const _SliverPersistentHeaderDelegate(this._tabBar);

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverPersistentHeaderDelegate oldDelegate) {
    return _tabBar != oldDelegate._tabBar;
  }

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: AppColors.white,
      child: _tabBar,
    );
  }
}
