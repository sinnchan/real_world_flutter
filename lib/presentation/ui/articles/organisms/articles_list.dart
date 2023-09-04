import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/article_list_item.dart';

class ArticlesList extends HookConsumerWidget {
  final ArticlesDataSource dataSource;

  const ArticlesList({
    super.key,
    required this.dataSource,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = useListenable(dataSource);

    return ListView.builder(
      itemCount: source.itemCount,
      itemBuilder: (context, index) {
        final item = source.getByIndex(index);
        return item.when(
          isLoading: () {
            return const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          data: (data) {
            return ArticleListItem(
              data: data,
              isLastItem: source.itemCount != index + 1,
            );
          },
        );
      },
    );
  }
}
