import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/model/article.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/article_author.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/favorite_counter.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/lsit_item/article_list_item_notifier.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/lsit_item/article_list_item_view_model.dart';
import 'package:real_world_flutter/presentation/ui/common/color/ext_color.dart';

class ArticleListItem extends HookConsumerWidget {
  final Article data;
  final bool isLastItem;
  final void Function(Article)? onUpdateArticle;

  const ArticleListItem({
    super.key,
    required this.data,
    required this.isLastItem,
    this.onUpdateArticle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ArticleListItemNotifier.provider(data);
    final vm = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    // setup listener
    useEffect(
      () {
        notifier.updateArticleLitener = onUpdateArticle;
        return null;
      },
      [notifier],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(vm, notifier),
          _contents(notifier),
          const SizedBox(height: 8),
          _tags(),
          const SizedBox(height: 8),
          if (isLastItem) const Divider(),
        ],
      ),
    );
  }

  Row _header(
    ArticleListItemViewModel vm,
    ArticleListItemNotifier notifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArticleAuthor(
          username: vm.artile.author.username,
          image: vm.artile.author.image,
          createdAt: vm.artile.createdAt,
          onTap: notifier.onTapAuthorInfo,
        ),
        FavoriteCounter(
          favoritesCount: vm.artile.favoritesCount,
          favorited: vm.artile.favorited,
          onTap:
              vm.isLockedFavoriteButton ? null : notifier.onTapFavoriteButton,
        ),
      ],
    );
  }

  Widget _contents(ArticleListItemNotifier notifier) {
    return InkWell(
      onTap: notifier.onTapContents,
      splashColor: AppColors.main.withLight(0.4),
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          _title(),
          const SizedBox(height: 5),
          _description(),
        ],
      ),
    );
  }

  Widget _tags() {
    if (data.tagList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 6,
      runSpacing: 6,
      children: data.tagList.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(useContext()).dividerColor),
          ),
          child: Text(
            e,
            style: const TextStyle(color: AppColors.grey),
          ),
        );
      }).toList(),
    );
  }

  Text _description() {
    return Text(
      data.description,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _title() {
    return Text(
      data.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
