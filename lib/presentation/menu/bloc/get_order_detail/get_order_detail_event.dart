part of 'get_order_detail_bloc.dart';

@freezed
class GetOrderDetailEvent with _$GetOrderDetailEvent {
  const factory GetOrderDetailEvent.started() = _Started;
  const factory GetOrderDetailEvent.getOrderDetail({
    required int id,
  }) = _GetOrderDetail;
}