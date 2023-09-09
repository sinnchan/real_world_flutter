import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/model/profile.dart';
import 'package:real_world_flutter/domain/model/result.dart';
import 'package:real_world_flutter/domain/repository/base/base_repository.dart';
import 'package:real_world_flutter/domain/repository/base/repository_fail_type.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/infrastructure/api/real_world_api.dart';
import 'package:real_world_flutter/infrastructure/api/schema/profile/api_profile.dart';
import 'package:real_world_flutter/infrastructure/transfer/secure_storage.dart';

class ProfileRepository extends BaseRepository {
  ProfileRepository({
    required super.api,
    required super.secStorage,
  });

  static final provider = Provider.autoDispose((ref) {
    sLogger.d('Instantinate profile repository');
    ref.onDispose(() {
      sLogger.d('Dispose profile repository');
    });

    return ProfileRepository(
      api: ref.watch(RealWorldApi.provider),
      secStorage: ref.watch(SecureStorage.provider),
    );
  });

  Future<RepositoryResult<Profile>> getProfile({
    required String username,
  }) async {
    sLogger.i('ProfileRepository.getProfile()');

    final result = await apiResultWrapper(() {
      return api.getProfile(username: username);
    });

    return result.successMap(
      transform: (data) {
        return _toProfileFromApiResponse(data.profile);
      },
    );
  }

  Future<RepositoryResult<Profile>> follow({
    required String username,
  }) async {
    sLogger.i('ProfileRepository.follow()');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    final result = await apiResultWrapper(() {
      return api.postFollow(
        username: username,
        token: ApiToken(token),
      );
    });

    return result.successMap(
      transform: (data) {
        return _toProfileFromApiResponse(data.profile);
      },
    );
  }

  Future<RepositoryResult<Profile>> unfollow({
    required String username,
  }) async {
    sLogger.i('ProfileRepository.unfollow()');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    final result = await apiResultWrapper(() {
      return api.deleteFollow(
        username: username,
        token: ApiToken(token),
      );
    });

    return result.successMap(
      transform: (data) {
        return _toProfileFromApiResponse(data.profile);
      },
    );
  }

  Profile _toProfileFromApiResponse(ApiProfile data) {
    return Profile(
      username: data.username,
      bio: data.bio ?? '',
      image: data.image,
      following: data.following,
    );
  }
}
