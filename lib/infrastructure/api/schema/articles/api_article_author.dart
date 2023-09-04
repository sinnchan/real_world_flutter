import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_article_author.freezed.dart';
part 'api_article_author.g.dart';

@freezed
class ApiArticleAuthor with _$ApiArticleAuthor {
  const factory ApiArticleAuthor({
    required String username,
    String? bio,
    required Uri image,
    required bool following,
  }) = _ApiArticleAuthor;

  factory ApiArticleAuthor.fromJson(Map<String, dynamic> json) =>
      _$ApiArticleAuthorFromJson(json);
}
