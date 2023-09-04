import 'dart:async';

import 'package:dio/dio.dart';
import 'package:real_world_flutter/domain/model/result.dart';
import 'package:real_world_flutter/domain/repository/base/repository_fail_type.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/infrastructure/api/real_world_api.dart';
import 'package:real_world_flutter/infrastructure/transfer/secure_storage.dart';

typedef RepositoryResult<T> = Result<T, RepositoryFailType>;

abstract class BaseRepository {
  final RealWorldApi api;
  final SecureStorage secStorage;

  BaseRepository({
    required this.api,
    required this.secStorage,
  });

  Future<Result<T, RepositoryFailType>> apiResultWrapper<T>(
    FutureOr<T> Function() request,
  ) async {
    try {
      final result = await request.call();
      return Result.success(result);
    } on DioException catch (e, st) {
      pLogger.e(
        'api error: ${e.requestOptions.uri.path}',
        error: e,
        stackTrace: st,
      );
      return Result.failed(toRepositoryFailType(e));
    } catch (_) {
      rethrow;
    }
  }

  RepositoryFailType toRepositoryFailType(DioException ex) {
    return switch (ex.response?.statusCode) {
      401 => const RepositoryFailType.unauthorized(),
      422 => RepositoryFailType.unexpected(
          message: ex.response?.statusMessage ?? 'unknown error',
        ),
      _ => const RepositoryFailType.unexpected(message: 'unknown error'),
    };
  }
}
