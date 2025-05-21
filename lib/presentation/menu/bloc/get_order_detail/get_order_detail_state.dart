part of 'get_order_detail_bloc.dart';

@freezed
class GetOrderDetailState with _$GetOrderDetailState {
  const factory GetOrderDetailState.initial() = _Initial;
  const factory GetOrderDetailState.loading() = _Loading;
  const factory GetOrderDetailState.loaded(Order? order) = _Loaded;
  const factory GetOrderDetailState.error(String message) = _Error;
}
