import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:synchronized/extension.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage;
  final _streams = <SecureStorageKey, BehaviorSubject<String?>>{};

  SecureStorage(this._secureStorage);

  static final provider = Provider.autoDispose((ref) {
    sLogger.d('Instantinate Secure storage');
    final instance = SecureStorage(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    );

    ref.onDispose(() => instance.dispose());

    return instance;
  });

  void dispose() {
    for (final stream in _streams.values) {
      stream.sink.close();
    }
    _streams.clear();
    sLogger.d('Disposed secure storage');
  }

  Stream<String?> watch(SecureStorageKey key) async* {
    yield* await synchronized(() async {
      final cachedStream = _streams[key];
      if (cachedStream != null) {
        return cachedStream;
      }

      // make stream
      final currentValue = await read(key);
      final newStream = BehaviorSubject.seeded(currentValue);
      _streams[key] = newStream;

      return newStream;
    });
  }

  Future<String?> read(SecureStorageKey key) {
    return _secureStorage.read(key: key.name);
  }

  Future<void> write(SecureStorageKey key, String value) async {
    await _secureStorage.write(
      key: key.name,
      value: value,
    );

    _streams[key]?.add(value);
  }

  Future<void> delete(SecureStorageKey key) async {
    await _secureStorage.delete(key: key.name);

    _streams[key]?.add(null);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();

    for (final stream in _streams.values) {
      stream.add(null);
    }
  }
}

enum SecureStorageKey {
  token,
}
