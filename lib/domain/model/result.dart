import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T, E> with _$Result<T, E> {
  const factory Result.success(T data) = _ResultSuccess;
  const factory Result.failed(E error) = _ResultFailed;
}

extension ResultMap<T1, E1> on Result<T1, E1> {
  Result<T2, E2> resultMap<T2, E2>({
    required T2 Function(T1) success,
    required E2 Function(E1) failed,
  }) {
    return when(
      success: (d) => Result.success(success.call(d)),
      failed: (e) => Result.failed(failed.call(e)),
    );
  }

  Result<T2, E1> successMap<T2>({
    required T2 Function(T1) transform,
  }) {
    return when(
      success: (d) => Result.success(transform.call(d)),
      failed: (e) => Result.failed(e),
    );
  }

  Result<T1, E2> failedMap<E2>({
    required E2 Function(E1) transform,
  }) {
    return when(
      success: (d) => Result.success(d),
      failed: (e) => Result.failed(transform.call(e)),
    );
  }
}
