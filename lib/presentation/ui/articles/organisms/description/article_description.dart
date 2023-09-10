import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/article_author.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/favorite_button.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/shared/shared_article_notifier.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/shared/shared_article_view_model.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/description/article_description_notifier.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/description/article_description_view_model.dart';
import 'package:real_world_flutter/presentation/ui/profile/molecules/shared/profile_follow_button.dart';

class ArticleDescription extends HookConsumerWidget {
  final String slug;
  const ArticleDescription({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ArticleDescriptionNotifier.provider(slug);
    final notifier = ref.watch(provider.notifier);
    final vm = ref.watch(provider);

    _ifNeedShowDialog(context, vm, notifier);

    final baseArticle = vm.article;
    if (baseArticle == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // for watch other changes
    final sharedArticleProvider = SharedArticleNotifier.provider(slug);
    final sharedArticleNotifier = ref.watch(sharedArticleProvider.notifier);
    final sharedArticle = ref.watch(sharedArticleProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(sharedArticleNotifier, sharedArticle),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Text(
              sharedArticle.artile?.body ?? '---',
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Container _header(
    SharedArticleNotifier sharedArticleNotifier,
    SharedArticleViewModel sharedArticle,
  ) {
    return Container(
      color: AppColors.darkGrey,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      child: Column(
        children: [
          Text(
            sharedArticle.artile?.title ?? '---',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ArticleAuthor(
            username: sharedArticle.artile?.author.username ?? '---',
            createdAt: sharedArticle.artile?.createdAt,
            onTap: sharedArticle.isLockedFavoriteButton
                ? null
                : sharedArticleNotifier.onTapAuthorInfo,
            textColor: AppColors.white,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ProfileFollowButton(
                username: sharedArticle.artile?.author.username,
              ),
              const SizedBox(width: 20),
              FavoriteButton(
                favoritesCount: sharedArticle.artile?.favoritesCount ?? 0,
                favorited: sharedArticle.artile?.favorited ?? false,
                onTap: sharedArticle.isLockedFavoriteButton
                    ? null
                    : sharedArticleNotifier.onTapFavoriteButton,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _ifNeedShowDialog(
    BuildContext context,
    ArticleDescriptionViewModel vm,
    ArticleDescriptionNotifier notifier,
  ) {
    final error = vm.errorMessage;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(error),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    notifier.onTapErorDialogOk();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }
}
