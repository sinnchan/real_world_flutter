import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:real_world_flutter/domain/model/article.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/article_author.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/favorite_counter.dart';

class ArticleListItem extends HookWidget {
  final Article data;
  final bool isLastItem;

  const ArticleListItem({
    super.key,
    required this.data,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArticleAuthor(
                username: data.author.username,
                image: data.author.image,
                createdAt: data.createdAt,
              ),
              FavoriteCounter(
                favoritesCount: data.favoritesCount,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _title(),
          const SizedBox(height: 5),
          _description(),
          const SizedBox(height: 8),
          _tags(),
          const SizedBox(height: 8),
          if (isLastItem) const Divider(),
        ],
      ),
    );
  }

  Wrap _tags() {
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

  Text _title() {
    return Text(
      data.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
