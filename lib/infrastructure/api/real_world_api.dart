import 'dart:async';

import 'package:dio/dio.dart' hide Headers;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_single_article_response.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_articles_response.dart';
import 'package:real_world_flutter/infrastructure/api/schema/user/api_user.dart';
import 'package:retrofit/retrofit.dart';

part 'real_world_api.g.dart';

@RestApi(baseUrl: 'http://sinnchan.com/api')
abstract class RealWorldApi {
  static const _headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static final provider = Provider((ref) {
    return RealWorldApi(Dio());
  });

  factory RealWorldApi(
    Dio dio, {
    String baseUrl,
  }) = _RealWorldApi;

  // user

  @POST('/users/login')
  @Headers(_headers)
  Future<ApiUserResponse> postUserLogin(
    @Body() Map<String, dynamic> body,
  );

  @POST('/users')
  @Headers(_headers)
  Future<ApiUserResponse> postUser(
    @Body() Map<String, dynamic> body,
  );

  @GET('/user')
  @Headers(_headers)
  Future<ApiUserResponse> getUser({
    @Header('Authorization') required ApiToken token,
  });

  @PUT('/user')
  @Headers(_headers)
  Future<ApiUserResponse> putUser({
    @Header('Authorization') required ApiToken token,
    @Body() required Map<String, dynamic> body,
  });

  // articles

  @GET('/articles/feed')
  @Headers(_headers)
  Future<ApiArticlesResponse> getFeed({
    @Query('offset') int? offset,
    @Query('limit') int? limit,
    @Header('Authorization') required ApiToken token,
  });

  @GET('/articles')
  @Headers(_headers)
  Future<ApiArticlesResponse> getArticles({
    @Query('tag') String? tag,
    @Query('author') String? authorName,
    @Query('favorited') String? favoritedUserName,
    @Query('offset') int? offset,
    @Query('limit') int? limit,
  });

  @POST('/articles')
  @Headers(_headers)
  Future<ApiSingleArticleResponse> postArticle({
    @Body() required Map<String, dynamic> body,
    @Header('Authorization') required ApiToken token,
  });

  @GET('/articles/{slug}')
  @Headers(_headers)
  Future<ApiSingleArticleResponse> getArticle({
    @Path('slug') required String slug,
  });

  @PUT('/articles/{slug}')
  @Headers(_headers)
  Future<ApiSingleArticleResponse> putArticle({
    @Path('slug') required String slug,
    @Body() required Map<String, dynamic> body,
    @Header('Authorization') required ApiToken token,
  });

  @DELETE('/articles/{slug}')
  @Headers(_headers)
  Future<void> deleteArticle({
    @Path('slug') required String slug,
    @Header('Authorization') required ApiToken token,
  });
}

class ApiToken {
  final String token;
  const ApiToken(this.token);

  @override
  String toString() {
    return 'Token $token';
  }
}
