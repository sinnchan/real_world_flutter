import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/model/result.dart';
import 'package:real_world_flutter/domain/repository/base/base_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/infrastructure/api/real_world_api.dart';
import 'package:real_world_flutter/infrastructure/transfer/secure_storage.dart';

class TagRepository extends BaseRepository {
  TagRepository({
    required super.api,
    required super.secStorage,
  });

  static final provider = Provider.autoDispose((ref) {
    sLogger.d('Instantinate tag repository');
    ref.onDispose(() {
      sLogger.d('Dispose tag repository');
    });

    return TagRepository(
      api: ref.watch(RealWorldApi.provider),
      secStorage: ref.watch(SecureStorage.provider),
    );
  });

  Future<RepositoryResult<List<String>>> getTags() async {
    sLogger.i('TagRepository.getTag()');

    final result = await apiResultWrapper(() {
      return api.getTags();
    });

    return result.successMap(
      transform: (data) {
        return data.tags;
      },
    );
  }
}
