part of 'get_order_bloc.dart';

@freezed
class GetOrderState with _$GetOrderState {
  const factory GetOrderState.initial() = _Initial;
  const factory GetOrderState.loading() = _Loading;
  const factory GetOrderState.loaded(List<Order> orders) = _Loaded;
  const factory GetOrderState.error(String message) = _Error;
}
