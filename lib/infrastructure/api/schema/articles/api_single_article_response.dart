import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_article.dart';

part 'api_single_article_response.freezed.dart';
part 'api_single_article_response.g.dart';

@freezed
class ApiSingleArticleResponse with _$ApiSingleArticleResponse {
  const factory ApiSingleArticleResponse({
    required ApiArticle article,
  }) = _ApiSingleArticleResponse;

  factory ApiSingleArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiSingleArticleResponseFromJson(json);
}
