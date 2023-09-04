import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_article.dart';

part 'api_articles_response.freezed.dart';
part 'api_articles_response.g.dart';

@freezed
class ApiArticlesResponse with _$ApiArticlesResponse {
  const factory ApiArticlesResponse({
    required List<ApiArticle> articles,
    required int articlesCount,
  }) = _ApiArticlesResponse;

  factory ApiArticlesResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiArticlesResponseFromJson(json);
}
