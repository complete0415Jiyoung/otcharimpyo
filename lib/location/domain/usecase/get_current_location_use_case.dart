import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/location.dart';
import '../repository/location_repository.dart';
import '../../../core/error/result.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<AsyncValue<Location>> execute() async {
    final result = await _repository.getCurrentLocation();

    return switch (result) {
      Success(:final value) => AsyncValue.data(value),
      Error(:final failure) => AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        ),
    };
  }
}
