part of 'get_popular_menu_bloc.dart';

@freezed
class GetPopularMenuState with _$GetPopularMenuState {
  const factory GetPopularMenuState.initial() = _Initial;
  const factory GetPopularMenuState.loading() = _Loading;
  const factory GetPopularMenuState.loaded(List<Datum>  pupularResponseModel) = _Loaded;
  const factory GetPopularMenuState.error(String message) = _Error;
}
