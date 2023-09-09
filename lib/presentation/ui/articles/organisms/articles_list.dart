import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/lsit_item/article_list_item.dart';

class ArticlesList extends HookConsumerWidget {
  final ArticlesDataSource dataSource;

  const ArticlesList({
    super.key,
    required this.dataSource,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = useListenable(dataSource);

    if (source.itemCount == 0) {
      return const Center(
        child: Text('No articles...'),
      );
    }

    final errMsg = source.errorMessage;
    if (errMsg != null) {
      _showErrorDialog(context, errMsg, source);
      return const Center(
        child: Icon(
          Icons.warning,
          size: 30,
          color: AppColors.lightGray,
        ),
      );
    }

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
              onUpdateArticle: (artile) {
                source.updateArticle(artile);
              },
            );
          },
        );
      },
    );
  }

  void _showErrorDialog(
    BuildContext context,
    String errMsg,
    ArticlesDataSource source,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errMsg),
            actions: [
              ElevatedButton(
                onPressed: () {
                  source.reload();
                  Navigator.pop(context);
                },
                child: const Text('Retry'),
              ),
            ],
          );
        },
      );
    });
  }
}
