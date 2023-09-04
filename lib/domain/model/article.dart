import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/domain/model/author.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required String slug,
    required String title,
    required String description,
    required String body,
    required List<String> tagList,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool favorited,
    required int favoritesCount,
    required Author author,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
