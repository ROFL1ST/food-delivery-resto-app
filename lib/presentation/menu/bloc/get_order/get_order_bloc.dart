import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/order_remote_datasource.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_order_event.dart';
part 'get_order_state.dart';
part 'get_order_bloc.freezed.dart';

class GetOrderBloc extends Bloc<GetOrderEvent, GetOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  GetOrderBloc(this.orderRemoteDatasource) : super(const _Initial()) {
    on<_GetOrder>((event, emit) async {
      emit(const _Loading());
      final result = await orderRemoteDatasource.getOrder(event.status);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
      // TODO: implement event handler
    });
  }
}
