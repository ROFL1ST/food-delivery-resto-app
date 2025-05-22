part of 'update_oder_status_bloc.dart';

@freezed
class UpdateOderStatusEvent with _$UpdateOderStatusEvent {
  const factory UpdateOderStatusEvent.started() = _Started;
  const factory UpdateOderStatusEvent.updateOrderStatus({
    required int id,
    required String status,
    
  }) = _UpdateOrderStatus;

}