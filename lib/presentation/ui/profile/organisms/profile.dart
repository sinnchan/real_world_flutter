import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/common/color/ext_color.dart';

class Profile extends HookConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 200,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
            const SliverPersistentHeader(
              pinned: true,
              delegate: _SliverPersistentHeaderDelegate(
                TabBar(
                  tabs: [
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('hoge'),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('huga'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            ListView(
              children: [
                Container(color: Colors.pink[100], height: 200),
                Container(color: Colors.pink[200], height: 200),
                Container(color: Colors.pink[300], height: 200),
                Container(color: Colors.pink[400], height: 200),
                Container(color: Colors.pink[500], height: 200),
                Container(color: Colors.pink[600], height: 200),
              ],
            ),
            ListView(
              children: [
                Container(color: Colors.cyan[100], height: 200),
                Container(color: Colors.cyan[200], height: 200),
                Container(color: Colors.cyan[300], height: 200),
                Container(color: Colors.cyan[400], height: 200),
                Container(color: Colors.cyan[500], height: 200),
                Container(color: Colors.cyan[600], height: 200),
              ],
            ),
          ],
        ),
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
