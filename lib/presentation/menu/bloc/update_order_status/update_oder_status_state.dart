part of 'update_oder_status_bloc.dart';

@freezed
class UpdateOderStatusState with _$UpdateOderStatusState {
  const factory UpdateOderStatusState.initial() = _Initial;
  const factory UpdateOderStatusState.loading() = _Loading;
 
  const factory UpdateOderStatusState.error({
    required String message,
  }) = _Error;
  const factory UpdateOderStatusState.success() = _Success;
}
