part of 'get_overview_bloc.dart';

@freezed
class GetOverviewState with _$GetOverviewState {
  const factory GetOverviewState.initial() = _Initial;
  const factory GetOverviewState.loading() = _Loading;
  const factory GetOverviewState.loaded(OverviewResponse overviews) = _Loaded;
  const factory GetOverviewState.error(String message) = _Error;
}
