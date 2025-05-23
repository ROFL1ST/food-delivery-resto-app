part of 'get_overview_bloc.dart';

@freezed
class GetOverviewEvent with _$GetOverviewEvent {
  const factory GetOverviewEvent.started() = _Started;
  const factory GetOverviewEvent.getOverview() = _GetOverview;
}