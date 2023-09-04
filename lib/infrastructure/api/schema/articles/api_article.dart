import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_article_author.dart';

part 'api_article.freezed.dart';
part 'api_article.g.dart';

@freezed
class ApiArticle with _$ApiArticle {
  const factory ApiArticle({
    required String slug,
    required String title,
    required String description,
    required String body,
    required List<String> tagList,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool favorited,
    required int favoritesCount,
    required ApiArticleAuthor author,
  }) = _ApiArticle;

  factory ApiArticle.fromJson(Map<String, dynamic> json) =>
      _$ApiArticleFromJson(json);
}
