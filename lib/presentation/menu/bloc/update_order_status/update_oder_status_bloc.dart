import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/order_remote_datasource.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_oder_status_event.dart';
part 'update_oder_status_state.dart';
part 'update_oder_status_bloc.freezed.dart';

class UpdateOderStatusBloc
    extends Bloc<UpdateOderStatusEvent, UpdateOderStatusState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  UpdateOderStatusBloc(this.orderRemoteDatasource) : super(const _Initial()) {
    on<_UpdateOrderStatus>((event, emit) async {
      emit(const _Loading());
      final result = await orderRemoteDatasource.updateOrderStatus(
        event.id,
        event.status,
      );
      result.fold((l) => emit(_Error(message: l)), (r) {
        emit(const _Success());
        emit(const _Success());
      });
      // TODO: implement event handler
    });
  }
}
