import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage;
  final _streams = <SecureStorageKey, BehaviorSubject<String?>>{};

  SecureStorage(this._secureStorage);

  static final provider = Provider.autoDispose((ref) {
    final instance = SecureStorage(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    );

    ref.onDispose(() {
      instance.dispose();
    });

    return instance;
  });

  void dispose() {
    for (final stream in _streams.values) {
      stream.sink.close();
    }
    _streams.clear();
  }

  Stream<String?> watch(SecureStorageKey key) async* {
    final cachedStream = _streams[key];
    if (cachedStream != null) {
      yield* cachedStream.stream;
    }

    // make stream
    final currentValue = await read(key);
    final newStream = BehaviorSubject.seeded(currentValue);
    _streams[key] = newStream;

    yield* newStream;
  }

  Future<String?> read(SecureStorageKey key) {
    return _secureStorage.read(key: key.name);
  }

  Future<void> write(SecureStorageKey key, String value) {
    return _secureStorage.write(
      key: key.name,
      value: value,
    );
  }

  Future<void> delete(SecureStorageKey key) {
    return _secureStorage.delete(key: key.name);
  }

  Future<void> deleteAll() {
    return _secureStorage.deleteAll();
  }
}

enum SecureStorageKey {
  token,
}
