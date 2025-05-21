part of 'get_order_bloc.dart';

@freezed
class GetOrderEvent with _$GetOrderEvent {
  const factory GetOrderEvent.started() = _Started;
  const factory GetOrderEvent.getOrder({required String status}) = _GetOrder;
}
