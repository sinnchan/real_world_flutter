import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/model/result.dart';
import 'package:real_world_flutter/domain/model/user.dart';
import 'package:real_world_flutter/domain/repository/base/base_repository.dart';
import 'package:real_world_flutter/domain/repository/base/repository_fail_type.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/infrastructure/api/real_world_api.dart';
import 'package:real_world_flutter/infrastructure/api/schema/user/api_user.dart';
import 'package:real_world_flutter/infrastructure/transfer/secure_storage.dart';

class UserRepository extends BaseRepository {
  UserRepository({
    required super.api,
    required super.secStorage,
  });

  static final provider = Provider.autoDispose((ref) {
    sLogger.d('Instantinate user repository');
    ref.onDispose(() {
      sLogger.d('Dispose user repository');
    });

    return UserRepository(
      api: ref.watch(RealWorldApi.provider),
      secStorage: ref.watch(SecureStorage.provider),
    );
  });

  Stream<bool> get loginStatusStream {
    return secStorage
        .watch(SecureStorageKey.token)
        .map((token) => token != null);
  }

  Future<RepositoryResult<User>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    sLogger.i('UserRepository.signUp()');
    final request = {
      'user': {
        'username': username,
        'email': email,
        'password': password,
      },
    };

    final result = await apiResultWrapper(() {
      return api.postUserLogin(request);
    });

    return result.successMap(
      transform: (data) {
        return _toUserFromApiUserResponse(data);
      },
    );
  }

  Future<RepositoryResult<User>> signIn({
    required String email,
    required String password,
  }) async {
    sLogger.i('UserRepository.signIn()');
    final request = {
      'user': {
        'email': email,
        'password': password,
      },
    };

    final result = await apiResultWrapper(() {
      return api.postUserLogin(request);
    });

    return result.successMap(
      transform: (data) {
        secStorage.write(SecureStorageKey.token, data.user.token);
        return _toUserFromApiUserResponse(data);
      },
    );
  }

  Future<void> signOut() {
    sLogger.i('UserRepository.signOut()');
    return secStorage.delete(SecureStorageKey.token);
  }

  Future<RepositoryResult<User>> getUser() async {
    sLogger.i('UserRepository.getUser()');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    final result = await apiResultWrapper(() {
      return api.getUser(token: ApiToken(token));
    });

    return result.successMap(
      transform: (data) {
        return _toUserFromApiUserResponse(data);
      },
    );
  }

  Future<RepositoryResult<User>> updateUser(User user) async {
    sLogger.i('UserRepository.getUser()');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    final result = await apiResultWrapper(() {
      return api.getUser(token: ApiToken(token));
    });

    return result.successMap(
      transform: (data) {
        return _toUserFromApiUserResponse(data);
      },
    );
  }

  User _toUserFromApiUserResponse(ApiUserResponse data) {
    return User(
      email: data.user.email,
      username: data.user.username,
      bio: data.user.bio,
      image: data.user.image,
    );
  }
}
