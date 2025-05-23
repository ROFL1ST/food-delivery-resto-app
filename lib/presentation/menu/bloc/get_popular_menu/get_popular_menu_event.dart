part of 'get_popular_menu_bloc.dart';

@freezed
class GetPopularMenuEvent with _$GetPopularMenuEvent {
  const factory GetPopularMenuEvent.started() = _Started;
  const factory GetPopularMenuEvent.getPopularMenu() = _GetPopularMenu;
  
}